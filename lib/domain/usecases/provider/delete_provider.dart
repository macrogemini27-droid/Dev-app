import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/provider_repository.dart';

class DeleteProvider {
  final ProviderRepository repository;

  DeleteProvider(this.repository);

  Future<Either<Failure, void>> call(String providerId) async {
    return await repository.deleteProvider(providerId);
  }
}
