import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/provider_repository.dart';

class SetDefaultProvider {
  final ProviderRepository repository;

  SetDefaultProvider(this.repository);

  Future<Either<Failure, void>> call(String providerId) async {
    return await repository.setDefaultProvider(providerId);
  }
}
