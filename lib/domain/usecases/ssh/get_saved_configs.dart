import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/ssh_config.dart';
import '../../repositories/ssh_config_repository.dart';

class GetSavedConfigs {
  final SSHConfigRepository repository;

  GetSavedConfigs(this.repository);

  Future<Either<Failure, List<SSHConfig>>> call() async {
    return await repository.getSavedConfigs();
  }
}
