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
    final escapedPath = _escapeShellArgument(path);
    return await executeCommand('cat $escapedPath');
  }

  Future<void> writeFile(String path, String content) async {
    final escapedPath = _escapeShellArgument(path);
    final escapedContent = _escapeShellArgument(content);
    await executeCommand('echo $escapedContent > $escapedPath');
  }

  Future<List<String>> listDirectory(String path) async {
    final escapedPath = _escapeShellArgument(path);
    final result = await executeCommand('ls -1 $escapedPath');
    return result.split('\n').where((line) => line.isNotEmpty).toList();
  }

  void _updateStatus(SSHConnectionStatus status) {
    _currentStatus = status;
    _connectionStatusController.add(status);
  }

  String _escapeShellCommand(String command) {
    // Basic shell escaping - prevent command injection
    return command
        .replaceAll(r'\', r'\\')
        .replaceAll(r'$', r'\$')
        .replaceAll(r'`', r'\`')
        .replaceAll(r'"', r'\"');
  }

  String _escapeShellArgument(String arg) {
    // Wrap in single quotes and escape single quotes
    return "'${arg.replaceAll("'", r"'\''")}'";
  }

  Future<String> _readPrivateKey(String path) async {
    // This would read from secure storage in production
    throw UnimplementedError('Private key reading not implemented');
  }

  void dispose() {
    _connectionStatusController.close();
    disconnect();
  }
}
