// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ssh_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SSHConfigImpl _$$SSHConfigImplFromJson(Map<String, dynamic> json) =>
    _$SSHConfigImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      host: json['host'] as String,
      port: (json['port'] as num).toInt(),
      username: json['username'] as String,
      authType: $enumDecode(_$SSHAuthTypeEnumMap, json['authType']),
      password: json['password'] as String?,
      privateKeyPath: json['privateKeyPath'] as String?,
      passphrase: json['passphrase'] as String?,
      verifyHostKey: json['verifyHostKey'] as bool? ?? true,
      workingDirectory: json['workingDirectory'] as String?,
      lastConnected: json['lastConnected'] == null
          ? null
          : DateTime.parse(json['lastConnected'] as String),
    );

Map<String, dynamic> _$$SSHConfigImplToJson(_$SSHConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'host': instance.host,
      'port': instance.port,
      'username': instance.username,
      'authType': _$SSHAuthTypeEnumMap[instance.authType]!,
      'password': instance.password,
      'privateKeyPath': instance.privateKeyPath,
      'passphrase': instance.passphrase,
      'verifyHostKey': instance.verifyHostKey,
      'workingDirectory': instance.workingDirectory,
      'lastConnected': instance.lastConnected?.toIso8601String(),
    };

const _$SSHAuthTypeEnumMap = {
  SSHAuthType.password: 'password',
  SSHAuthType.privateKey: 'privateKey',
};
