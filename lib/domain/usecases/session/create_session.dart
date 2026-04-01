import 'package:dartz/dartz.dart';
import 'package:claude_code_mobile/core/errors/failures.dart';
import 'package:claude_code_mobile/domain/repositories/session_repository.dart';
import 'package:claude_code_mobile/domain/entities/session.dart';

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
