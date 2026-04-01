import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/tool.dart';
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
      'read_file': FileReadTool(sshRepository),
      'write_file': FileWriteTool(sshRepository),
      'edit_file': FileEditTool(sshRepository),
      'execute_command': BashTool(sshRepository),
      'search_files': GrepTool(sshRepository),
      'list_files': GlobTool(sshRepository),
    };
  }

  @override
  Future<Either<Failure, String>> executeTool({
    required String toolName,
    required Map<String, dynamic> arguments,
  }) async {
    try {
      final tool = _tools[toolName];
      if (tool == null) {
        return Left(ToolExecutionFailure(
          message: 'Tool not found: $toolName',
        ));
      }

      final result = await tool.execute(arguments);
      return Right(result);
    } catch (e) {
      return Left(ToolExecutionFailure(
        message: 'Tool execution failed: ${e.toString()}',
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

  Future<String> execute(Map<String, dynamic> arguments);
}
