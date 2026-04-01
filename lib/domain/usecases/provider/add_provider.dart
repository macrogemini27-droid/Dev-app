import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/provider_repository.dart';
import '../entities/provider_config.dart';

class AddProvider {
  final ProviderRepository repository;

  AddProvider(this.repository);

  Future<Either<Failure, void>> call(ProviderConfig provider) async {
    return await repository.addProvider(provider);
  }
}
