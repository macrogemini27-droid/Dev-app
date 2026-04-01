import 'package:dartz/dartz.dart';
import 'package:claude_code_mobile/core/errors/failures.dart';
import 'package:claude_code_mobile/domain/repositories/session_repository.dart';
import 'package:claude_code_mobile/domain/entities/session.dart';

class LoadSession {
  final SessionRepository repository;

  LoadSession(this.repository);

  Future<Either<Failure, Session>> call(String sessionId) async {
    return await repository.getSession(sessionId);
  }
}
