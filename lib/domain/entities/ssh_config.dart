import 'package:freezed_annotation/freezed_annotation.dart';

part 'ssh_config.freezed.dart';
part 'ssh_config.g.dart';

@freezed
class SSHConfig with _$SSHConfig {
  const factory SSHConfig({
    required String id,
    required String name,
    required String host,
    required int port,
    required String username,
    required SSHAuthType authType,
    String? password,
    String? privateKeyPath,
    String? passphrase,
    @Default(true) bool verifyHostKey,
    String? workingDirectory,
    DateTime? lastConnected,
  }) = _SSHConfig;

  factory SSHConfig.fromJson(Map<String, dynamic> json) =>
      _$SSHConfigFromJson(json);
}

enum SSHAuthType {
  password,
  privateKey,
}

enum SSHConnectionStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}
