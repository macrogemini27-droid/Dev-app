import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/tool.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/tool_repository.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../tools/file_read_tool.dart';
import '../tools/file_write_tool.dart';
import '../tools/file_edit_tool.dart';
import '../tools/bash_tool.dart';
import '../tools/grep_tool.dart';
import '../tools/glob_tool.dart';

class ToolRepositoryImpl implements ToolRepository {
  final SSHRepository sshRepository;
  late final Map<String, BaseTool> _tools;

  ToolRepositoryImpl({required this.sshRepository}) {
    _tools = {
      'Read': FileReadTool(sshRepository),
      'Write': FileWriteTool(sshRepository),
      'Edit': FileEditTool(sshRepository),
      'Bash': BashTool(sshRepository),
      'Grep': GrepTool(sshRepository),
      'Glob': GlobTool(sshRepository),
    };
  }

  @override
  Future<Either<Failure, ToolResult>> executeTool({
    required String toolName,
    required Map<String, dynamic> input,
    required ToolExecutionContext context,
  }) async {
    try {
      final tool = _tools[toolName];
      if (tool == null) {
        return Left(ToolExecutionFailure(
          message: 'Tool not found: $toolName',
        ));
      }

      final result = await tool.execute(input, context);
      return Right(result);
    } catch (e) {
      return Left(ToolExecutionFailure(
        message: 'Tool execution failed: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<ToolResult>>> executeBatch({
    required List<ToolCall> toolCalls,
    required ToolExecutionContext context,
  }) async {
    try {
      // Partition into read-only and write tools
      final readOnlyTools = <ToolCall>[];
      final writeTools = <ToolCall>[];

      for (final call in toolCalls) {
        final tool = _tools[call.name];
        if (tool != null && tool.isReadOnly) {
          readOnlyTools.add(call);
        } else {
          writeTools.add(call);
        }
      }

      final results = <ToolResult>[];

      // Execute read-only tools in parallel (max 10)
      if (readOnlyTools.isNotEmpty) {
        final futures = readOnlyTools.map((call) async {
          final result = await executeTool(
            toolName: call.name,
            input: call.input,
            context: context,
          );
          return result.fold(
            (failure) => ToolResult(
              toolCallId: call.id,
              content: failure.message,
              isError: true,
            ),
            (result) => result,
          );
        });

        final readResults = await Future.wait(futures);
        results.addAll(readResults);
      }

      // Execute write tools serially
      for (final call in writeTools) {
        final result = await executeTool(
          toolName: call.name,
          input: call.input,
          context: context,
        );

        results.add(
          result.fold(
            (failure) => ToolResult(
              toolCallId: call.id,
              content: failure.message,
              isError: true,
            ),
            (result) => result,
          ),
        );
      }

      return Right(results);
    } catch (e) {
      return Left(ToolExecutionFailure(
        message: 'Batch execution failed: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  List<Tool> getAvailableTools() {
    return _tools.values.map((tool) => tool.definition).toList();
  }

  @override
  Tool? getTool(String name) {
    return _tools[name]?.definition;
  }
}

abstract class BaseTool {
  Tool get definition;
  bool get isReadOnly;

  Future<ToolResult> execute(
    Map<String, dynamic> input,
    ToolExecutionContext context,
  );
}
