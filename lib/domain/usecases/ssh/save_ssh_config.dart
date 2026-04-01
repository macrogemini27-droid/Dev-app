import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/ssh_config.dart';
import '../../repositories/ssh_config_repository.dart';

class SaveSSHConfig {
  final SSHConfigRepository repository;

  SaveSSHConfig(this.repository);

  Future<Either<Failure, void>> call(SSHConfig config) async {
    return await repository.saveConfig(config);
  }
}
