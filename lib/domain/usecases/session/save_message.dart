import 'package:dartz/dartz.dart';
import 'package:claude_code_mobile/core/errors/failures.dart';
import 'package:claude_code_mobile/domain/repositories/session_repository.dart';
import 'package:claude_code_mobile/domain/entities/message.dart';

class SaveMessage {
  final SessionRepository repository;

  SaveMessage(this.repository);

  Future<Either<Failure, void>> call(Message message) async {
    return await repository.saveMessage(message);
  }
}
