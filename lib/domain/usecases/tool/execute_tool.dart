import 'package:dartz/dartz.dart';
import 'package:claude_code_mobile/core/errors/failures.dart';
import 'package:claude_code_mobile/domain/repositories/tool_repository.dart';
import 'package:claude_code_mobile/domain/entities/tool.dart';

class ExecuteTool {
  final ToolRepository repository;

  ExecuteTool(this.repository);

  Future<Either<Failure, String>> call(ToolExecutionParams params) async {
    return await repository.executeTool(
      toolName: params.toolName,
      arguments: params.arguments,
    );
  }
}
