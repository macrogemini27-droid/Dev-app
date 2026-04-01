import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/session_repository.dart';
import '../entities/message.dart';

class SaveMessage {
  final SessionRepository repository;

  SaveMessage(this.repository);

  Future<Either<Failure, void>> call(Message message) async {
    return await repository.saveMessage(message);
  }
}
