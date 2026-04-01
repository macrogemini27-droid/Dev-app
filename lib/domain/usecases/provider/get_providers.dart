import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/provider_repository.dart';
import '../entities/provider_config.dart';

class GetProviders {
  final ProviderRepository repository;

  GetProviders(this.repository);

  Future<Either<Failure, List<ProviderConfig>>> call() async {
    return await repository.getAllProviders();
  }
}
