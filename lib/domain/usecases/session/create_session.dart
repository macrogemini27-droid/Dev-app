import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/session_repository.dart';
import '../entities/session.dart';

class CreateSession {
  final SessionRepository repository;

  CreateSession(this.repository);

  Future<Either<Failure, Session>> call({
    required String name,
    required String sshConfigId,
    required String providerId,
    required String workingDirectory,
  }) async {
    return await repository.createSession(
      name: name,
      sshConfigId: sshConfigId,
      providerId: providerId,
      workingDirectory: workingDirectory,
    );
  }
}
