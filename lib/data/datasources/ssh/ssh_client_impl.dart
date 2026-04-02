import 'dart:async';
import 'dart:convert';
import 'package:dartssh2/dartssh2.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/ssh_config.dart';
import '../../../core/services/app_logger.dart';

class SSHClientImpl {
  SSHClient? _client;
  SSHSession? _session;
  SftpClient? _sftpClient;
  String? _currentWorkingDirectory;
  final _connectionStatusController = StreamController<SSHConnectionStatus>.broadcast();
  SSHConnectionStatus _currentStatus = SSHConnectionStatus.disconnected;
  final _logger = AppLogger();

  Stream<SSHConnectionStatus> get connectionStatus => _connectionStatusController.stream;
  bool get isConnected => _currentStatus == SSHConnectionStatus.connected;
  String? get currentWorkingDirectory => _currentWorkingDirectory;

  Future<void> connect(SSHConfig config) async {
    try {
      _logger.info('Connecting to SSH server: ${config.host}:${config.port}', tag: 'SSH');
      _updateStatus(SSHConnectionStatus.connecting);

      final socket = await SSHSocket.connect(
        config.host,
        config.port,
        timeout: Duration(seconds: AppConstants.sshConnectionTimeout),
      );

      _logger.debug('SSH socket connected, authenticating...', tag: 'SSH');
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

      _logger.debug('Opening SSH shell session', tag: 'SSH');
      _session = await _client!.shell();
      _currentWorkingDirectory = config.workingDirectory ?? '/';

      _logger.info('Successfully connected to ${config.host}', tag: 'SSH');
      _updateStatus(SSHConnectionStatus.connected);
    } catch (e) {
      _logger.error('SSH connection failed: ${e.toString()}', error: e, tag: 'SSH');
      _updateStatus(SSHConnectionStatus.error);
      throw SSHException(
        message: 'Failed to connect to SSH server: ${e.toString()}',
        details: e,
      );
    }
  }

  Future<void> disconnect() async {
    try {
      _logger.info('Disconnecting from SSH server', tag: 'SSH');
      _updateStatus(SSHConnectionStatus.disconnected);

      _sftpClient?.close();
      _session?.close();
      _client?.close();

      _sftpClient = null;
      _session = null;
      _client = null;
      _currentWorkingDirectory = null;

      _logger.info('Successfully disconnected', tag: 'SSH');
      _updateStatus(SSHConnectionStatus.disconnected);
    } catch (e) {
      _logger.error('Error during disconnect: ${e.toString()}', error: e, tag: 'SSH');
      _updateStatus(SSHConnectionStatus.error);
      throw SSHException(
        message: 'Failed to disconnect: ${e.toString()}',
        details: e,
      );
    }
  }

  Future<String> executeCommand(String command) async {
    if (!isConnected || _client == null) {
      _logger.error('Attempted to execute command while not connected', tag: 'SSH');
      throw SSHException(message: 'Not connected to SSH server');
    }

    try {
      _logger.debug('Executing command: $command', tag: 'SSH');
      
      final result = await _client!.run(command);

      final output = utf8.decode(result);
      _logger.debug('Command executed successfully, output length: ${output.length}', tag: 'SSH');
      
      return output;
    } catch (e) {
      _logger.error('Command execution failed: $command', error: e, tag: 'SSH');
      throw SSHException(
        message: 'Failed to execute command: ${e.toString()}',
        details: e,
      );
    }
  }

  Future<SftpClient> _getSftpClient() async {
    if (_sftpClient != null) {
      return _sftpClient!;
    }
    _sftpClient = await _client!.sftp();
    return _sftpClient!;
  }

  Future<String> readFile(String path) async {
    if (!isConnected) {
      throw SSHException(message: 'Not connected to SSH server');
    }

    try {
      final sftp = await _getSftpClient();
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
      final sftp = await _getSftpClient();
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
      final sftp = await _getSftpClient();
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

  String _wrapInSingleQuotes(String command) {
    final cleaned = command.replaceAll('\x00', '');
    final escaped = cleaned.replaceAll("'", r"'\''");
    return "'$escaped'";
  }

  String _escapeShellArgument(String arg) {
    final cleaned = arg.replaceAll('\x00', '');
    return "'${cleaned.replaceAll("'", r"'\''")}'";
  }

  Future<String> _readPrivateKey(String path) async {
    throw UnimplementedError('Private key reading not implemented');
  }

  Future<void> dispose() async {
    await _connectionStatusController.close();
    await disconnect();
  }
}
