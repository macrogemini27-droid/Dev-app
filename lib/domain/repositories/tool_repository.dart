import 'package:dartz/dartz.dart';
import '../entities/tool.dart';
import '../entities/message.dart';
import '../../core/errors/failures.dart';

abstract class ToolRepository {
  Future<Either<Failure, ToolResult>> executeTool({
    required String toolName,
    required Map<String, dynamic> input,
    required ToolExecutionContext context,
  });

  Future<Either<Failure, List<ToolResult>>> executeBatch({
    required List<ToolCall> toolCalls,
    required ToolExecutionContext context,
  });

  List<Tool> getAvailableTools();
  Tool? getTool(String name);
}
