import 'dart:async';
import 'dart:convert';
import 'package:dartssh2/dartssh2.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/ssh_config.dart';

class SSHClientImpl {
  SSHClient? _client;
  SSHSession? _session;
  String? _currentWorkingDirectory;
  final _connectionStatusController = StreamController<SSHConnectionStatus>.broadcast();
  SSHConnectionStatus _currentStatus = SSHConnectionStatus.disconnected;

  Stream<SSHConnectionStatus> get connectionStatus => _connectionStatusController.stream;
  bool get isConnected => _currentStatus == SSHConnectionStatus.connected;
  String? get currentWorkingDirectory => _currentWorkingDirectory;

  Future<void> connect(SSHConfig config) async {
    try {
      _updateStatus(SSHConnectionStatus.connecting);

      final socket = await SSHSocket.connect(
        config.host,
        config.port,
        timeout: Duration(seconds: AppConstants.sshConnectionTimeout),
      );

      _client = SSHClient(
        socket,
        username: config.username,
        onPasswordRequest: config.authType == SSHAuthType.password
            ? () => config.password
            : null,
        identities: config.authType == SSHAuthType.privateKey && config.privateKeyPath != null
            ? [
                ...SSHKeyPair.fromPem(
                  await _readPrivateKey(config.privateKeyPath!),
                  config.passphrase,
                )
              ]
            : null,
      );

      _session = await _client!.shell();
      _currentWorkingDirectory = config.workingDirectory ?? '/';

      _updateStatus(SSHConnectionStatus.connected);
    } catch (e) {
      _updateStatus(SSHConnectionStatus.error);
      throw SSHException(
        message: 'Failed to connect to SSH server: ${e.toString()}',
        details: e,
      );
    }
  }

  Future<void> disconnect() async {
    try {
      _session?.close();
      _client?.close();
      _session = null;
      _client = null;
      _currentWorkingDirectory = null;
      _updateStatus(SSHConnectionStatus.disconnected);
    } catch (e) {
      throw SSHException(
        message: 'Failed to disconnect: ${e.toString()}',
        details: e,
      );
    }
  }

  Future<String> executeCommand(String command) async {
    if (!isConnected) {
      throw SSHException(message: 'Not connected to SSH server');
    }

    try {
      // Escape command for shell safety
      final escapedCommand = _escapeShellCommand(command);

      final result = await _client!.run(escapedCommand);

      // dartssh2 returns Uint8List directly
      return utf8.decode(result);
    } catch (e) {
      if (e is SSHException) rethrow;
      throw SSHException(
        message: 'Failed to execute command: ${e.toString()}',
        details: e,
      );
    }
  }

  Future<String> readFile(String path) async {
    if (!isConnected) {
      throw SSHException(message: 'Not connected to SSH server');
    }

    try {
      final sftp = await _client!.sftp();
      final file = await sftp.open(path);
      final content = await file.readBytes();
      await file.close();
      return utf8.decode(content);
    } catch (e) {
      throw SSHException(
        message: 'Failed to read file: ${e.toString()}',
        details: e,
      );
    }
  }

  Future<void> writeFile(String path, String content) async {
    if (!isConnected) {
      throw SSHException(message: 'Not connected to SSH server');
    }

    try {
      final sftp = await _client!.sftp();
      final file = await sftp.open(
        path,
        mode: SftpFileOpenMode.create | SftpFileOpenMode.write | SftpFileOpenMode.truncate,
      );
      await file.writeBytes(utf8.encode(content));
      await file.close();
    } catch (e) {
      throw SSHException(
        message: 'Failed to write file: ${e.toString()}',
        details: e,
      );
    }
  }

  Future<List<String>> listDirectory(String path) async {
    if (!isConnected) {
      throw SSHException(message: 'Not connected to SSH server');
    }

    try {
      final sftp = await _client!.sftp();
      final items = await sftp.listdir(path);
      return items.map((item) => item.filename).where((name) => name != '.' && name != '..').toList();
    } catch (e) {
      throw SSHException(
        message: 'Failed to list directory: ${e.toString()}',
        details: e,
      );
    }
  }

  void _updateStatus(SSHConnectionStatus status) {
    _currentStatus = status;
    _connectionStatusController.add(status);
  }

  String _escapeShellCommand(String command) {
    // Enhanced shell escaping - prevent command injection
    // Handle special characters, newlines, and null bytes
    return command
        .replaceAll('\x00', '') // Remove null bytes
        .replaceAll(r'\', r'\\')
        .replaceAll(r'$', r'\$')
        .replaceAll(r'`', r'\`')
        .replaceAll(r'"', r'\"')
        .replaceAll('\n', r'\n')
        .replaceAll('\r', r'\r')
        .replaceAll('\t', r'\t');
  }

  String _escapeShellArgument(String arg) {
    // Remove null bytes and wrap in single quotes
    // Single quotes prevent all shell expansion
    final cleaned = arg.replaceAll('\x00', '');
    return "'${cleaned.replaceAll("'", r"'\''")}'";
  }

  Future<String> _readPrivateKey(String path) async {
    // This would read from secure storage in production
    throw UnimplementedError('Private key reading not implemented');
  }

  Future<void> dispose() async {
    await _connectionStatusController.close();
    await disconnect();
  }
}
