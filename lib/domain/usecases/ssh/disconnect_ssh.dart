import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/ssh_repository.dart';

class DisconnectSSH {
  final SSHRepository repository;

  DisconnectSSH(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.disconnect();
  }
}
