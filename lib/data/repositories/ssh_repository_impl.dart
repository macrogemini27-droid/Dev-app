import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/ssh_config.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../datasources/ssh/ssh_client_impl.dart';

class SSHRepositoryImpl implements SSHRepository {
  final SSHClientImpl sshClient;

  SSHRepositoryImpl({required this.sshClient});

  @override
  Future<Either<Failure, void>> connect(SSHConfig config) async {
    try {
      await sshClient.connect(config);
      return const Right(null);
    } on SSHException catch (e) {
      return Left(SSHConnectionFailure(
        message: e.message,
        code: e.code,
        details: e.details,
      ));
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Unexpected error during SSH connection: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      await sshClient.disconnect();
      return const Right(null);
    } on SSHException catch (e) {
      return Left(SSHConnectionFailure(
        message: e.message,
        code: e.code,
        details: e.details,
      ));
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Unexpected error during SSH disconnection: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> executeCommand(String command) async {
    try {
      final result = await sshClient.executeCommand(command);
      return Right(result);
    } on SSHException catch (e) {
      return Left(SSHCommandFailure(
        message: e.message,
        code: e.code,
        details: e.details,
      ));
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Unexpected error executing command: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> readFile(String path) async {
    try {
      final result = await sshClient.readFile(path);
      return Right(result);
    } on SSHException catch (e) {
      return Left(SSHCommandFailure(
        message: 'Failed to read file: ${e.message}',
        code: e.code,
        details: e.details,
      ));
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Unexpected error reading file: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> writeFile(String path, String content) async {
    try {
      await sshClient.writeFile(path, content);
      return const Right(null);
    } on SSHException catch (e) {
      return Left(SSHCommandFailure(
        message: 'Failed to write file: ${e.message}',
        code: e.code,
        details: e.details,
      ));
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Unexpected error writing file: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<String>>> listDirectory(String path) async {
    try {
      final result = await sshClient.listDirectory(path);
      return Right(result);
    } on SSHException catch (e) {
      return Left(SSHCommandFailure(
        message: 'Failed to list directory: ${e.message}',
        code: e.code,
        details: e.details,
      ));
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Unexpected error listing directory: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Stream<SSHConnectionStatus> get connectionStatus => sshClient.connectionStatus;

  @override
  bool get isConnected => sshClient.isConnected;

  @override
  String? get currentWorkingDirectory => sshClient.currentWorkingDirectory;
}
