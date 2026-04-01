import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/ssh_repository.dart';

class ExecuteCommand {
  final SSHRepository repository;

  ExecuteCommand(this.repository);

  Future<Either<Failure, String>> call(String command) async {
    return await repository.executeCommand(command);
  }
}
