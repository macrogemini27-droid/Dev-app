import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/tool_repository.dart';
import '../entities/tool.dart';
import '../entities/message.dart';

class ExecuteTool {
  final ToolRepository repository;

  ExecuteTool(this.repository);

  Future<Either<Failure, ToolResult>> call({
    required String toolName,
    required Map<String, dynamic> input,
    required ToolExecutionContext context,
  }) async {
    return await repository.executeTool(
      toolName: toolName,
      input: input,
      context: context,
    );
  }
}
