import 'package:dartz/dartz.dart';
import 'package:claude_code_mobile/core/errors/failures.dart';
import 'package:claude_code_mobile/domain/repositories/ssh_repository.dart';

class DisconnectSSH {
  final SSHRepository repository;

  DisconnectSSH(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.disconnect();
  }
}
