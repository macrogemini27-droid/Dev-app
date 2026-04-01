import 'package:dartz/dartz.dart';
import '../entities/ssh_config.dart';
import '../../core/errors/failures.dart';

abstract class SSHRepository {
  Future<Either<Failure, void>> connect(SSHConfig config);
  Future<Either<Failure, void>> disconnect();
  Future<Either<Failure, String>> executeCommand(String command);
  Future<Either<Failure, String>> readFile(String path);
  Future<Either<Failure, void>> writeFile(String path, String content);
  Future<Either<Failure, List<String>>> listDirectory(String path);
  Stream<SSHConnectionStatus> get connectionStatus;
  bool get isConnected;
  String? get currentWorkingDirectory;
}
