import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/ssh_config.dart';

abstract class SSHConfigRepository {
  Future<Either<Failure, List<SSHConfig>>> getSavedConfigs();
  Future<Either<Failure, void>> saveConfig(SSHConfig config);
  Future<Either<Failure, void>> deleteConfig(String id);
  Future<Either<Failure, SSHConfig>> getConfigById(String id);
  Future<Either<Failure, void>> updateConfig(SSHConfig config);
}
