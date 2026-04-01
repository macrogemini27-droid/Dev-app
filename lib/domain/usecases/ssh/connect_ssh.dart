import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/ssh_repository.dart';
import '../entities/ssh_config.dart';

class ConnectSSH {
  final SSHRepository repository;

  ConnectSSH(this.repository);

  Future<Either<Failure, void>> call(SSHConfig config) async {
    return await repository.connect(config);
  }
}
