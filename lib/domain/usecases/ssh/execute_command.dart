import 'package:dartz/dartz.dart';
import 'package:claude_code_mobile/core/errors/failures.dart';
import 'package:claude_code_mobile/domain/repositories/ssh_repository.dart';

class ExecuteCommand {
  final SSHRepository repository;

  ExecuteCommand(this.repository);

  Future<Either<Failure, String>> call(String command) async {
    return await repository.executeCommand(command);
  }
}
