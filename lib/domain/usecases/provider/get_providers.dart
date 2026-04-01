import 'package:dartz/dartz.dart';
import 'package:claude_code_mobile/core/errors/failures.dart';
import 'package:claude_code_mobile/domain/repositories/provider_repository.dart';
import 'package:claude_code_mobile/domain/entities/provider_config.dart';

class GetProviders {
  final ProviderRepository repository;

  GetProviders(this.repository);

  Future<Either<Failure, List<ProviderConfig>>> call() async {
    return await repository.getAllProviders();
  }
}
