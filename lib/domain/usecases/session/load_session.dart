import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/session_repository.dart';
import '../entities/session.dart';

class LoadSession {
  final SessionRepository repository;

  LoadSession(this.repository);

  Future<Either<Failure, Session>> call(String sessionId) async {
    return await repository.getSession(sessionId);
  }
}
