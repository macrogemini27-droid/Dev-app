import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/ssh_config_repository.dart';

class DeleteSSHConfig {
  final SSHConfigRepository repository;

  DeleteSSHConfig(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteConfig(id);
  }
}
