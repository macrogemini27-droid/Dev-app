import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/provider_config.dart';
import '../../repositories/provider_repository.dart';

class UpdateProvider {
  final ProviderRepository repository;

  UpdateProvider(this.repository);

  Future<Either<Failure, void>> call(ProviderConfig provider) async {
    return await repository.updateProvider(provider);
  }
}
