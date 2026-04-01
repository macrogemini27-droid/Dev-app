import 'package:dartz/dartz.dart';
import '../entities/session.dart';
import '../entities/message.dart';
import '../../core/errors/failures.dart';

abstract class SessionRepository {
  Future<Either<Failure, Session>> createSession({
    required String name,
    required String sshConfigId,
    required String providerId,
    required String workingDirectory,
  });

  Future<Either<Failure, Session>> getSession(String id);
  Future<Either<Failure, List<Session>>> getAllSessions();
  Future<Either<Failure, void>> deleteSession(String id);
  Future<Either<Failure, void>> saveMessage(Message message);
  Future<Either<Failure, List<Message>>> getMessages(
    String sessionId, {
    int limit = 50,
    int offset = 0,
  });
}
