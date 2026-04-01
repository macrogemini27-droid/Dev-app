import 'package:dartz/dartz.dart';
import 'package:claude_code_mobile/core/errors/failures.dart';
import 'package:claude_code_mobile/domain/repositories/tool_repository.dart';
import 'package:claude_code_mobile/domain/entities/tool.dart';
import 'package:claude_code_mobile/domain/entities/message.dart';

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
