import 'package:dartz/dartz.dart';
import 'package:claude_code_mobile/core/errors/failures.dart';
import 'package:claude_code_mobile/domain/repositories/ssh_repository.dart';
import 'package:claude_code_mobile/domain/entities/ssh_config.dart';

class ConnectSSH {
  final SSHRepository repository;

  ConnectSSH(this.repository);

  Future<Either<Failure, void>> call(SSHConfig config) async {
    return await repository.connect(config);
  }
}
