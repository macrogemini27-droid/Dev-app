import 'package:dartz/dartz.dart';
import '../entities/provider_config.dart';
import '../../core/errors/failures.dart';

abstract class ProviderRepository {
  Future<Either<Failure, void>> addProvider(ProviderConfig provider);
  Future<Either<Failure, List<ProviderConfig>>> getAllProviders();
  Future<Either<Failure, ProviderConfig>> getProvider(String id);
  Future<Either<Failure, void>> updateProvider(ProviderConfig provider);
  Future<Either<Failure, void>> deleteProvider(String id);
  Future<Either<Failure, ProviderConfig?>> getDefaultProvider();
  Future<Either<Failure, void>> setDefaultProvider(String id);
}
