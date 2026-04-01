import 'package:dartz/dartz.dart';
import 'package:claude_code_mobile/core/errors/failures.dart';
import 'package:claude_code_mobile/domain/repositories/provider_repository.dart';
import 'package:claude_code_mobile/domain/entities/provider_config.dart';

class AddProvider {
  final ProviderRepository repository;

  AddProvider(this.repository);

  Future<Either<Failure, void>> call(ProviderConfig provider) async {
    return await repository.addProvider(provider);
  }
}
