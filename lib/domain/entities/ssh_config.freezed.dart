// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ssh_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SSHConfig _$SSHConfigFromJson(Map<String, dynamic> json) {
  return _SSHConfig.fromJson(json);
}

/// @nodoc
mixin _$SSHConfig {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get host => throw _privateConstructorUsedError;
  int get port => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  SSHAuthType get authType => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  String? get privateKeyPath => throw _privateConstructorUsedError;
  String? get passphrase => throw _privateConstructorUsedError;
  bool get verifyHostKey => throw _privateConstructorUsedError;
  String? get workingDirectory => throw _privateConstructorUsedError;
  DateTime? get lastConnected => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SSHConfigCopyWith<SSHConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SSHConfigCopyWith<$Res> {
  factory $SSHConfigCopyWith(SSHConfig value, $Res Function(SSHConfig) then) =
      _$SSHConfigCopyWithImpl<$Res, SSHConfig>;
  @useResult
  $Res call(
      {String id,
      String name,
      String host,
      int port,
      String username,
      SSHAuthType authType,
      String? password,
      String? privateKeyPath,
      String? passphrase,
      bool verifyHostKey,
      String? workingDirectory,
      DateTime? lastConnected});
}

/// @nodoc
class _$SSHConfigCopyWithImpl<$Res, $Val extends SSHConfig>
    implements $SSHConfigCopyWith<$Res> {
  _$SSHConfigCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? host = null,
    Object? port = null,
    Object? username = null,
    Object? authType = null,
    Object? password = freezed,
    Object? privateKeyPath = freezed,
    Object? passphrase = freezed,
    Object? verifyHostKey = null,
    Object? workingDirectory = freezed,
    Object? lastConnected = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id,
      name: null == name
          ? _value.name
          : name,
      host: null == host
          ? _value.host
          : host,
      port: null == port
          ? _value.port
          : port,
      username: null == username
          ? _value.username
          : username,
      authType: null == authType
          ? _value.authType
          : authType,
      password: freezed == password
          ? _value.password
          : password,
      privateKeyPath: freezed == privateKeyPath
          ? _value.privateKeyPath
          : privateKeyPath,
      passphrase: freezed == passphrase
          ? _value.passphrase
          : passphrase,
      verifyHostKey: null == verifyHostKey
          ? _value.verifyHostKey
          : verifyHostKey,
      workingDirectory: freezed == workingDirectory
          ? _value.workingDirectory
          : workingDirectory,
      lastConnected: freezed == lastConnected
          ? _value.lastConnected
          : lastConnected,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SSHConfigImplCopyWith<$Res>
    implements $SSHConfigCopyWith<$Res> {
  factory _$$SSHConfigImplCopyWith(
          _$SSHConfigImpl value, $Res Function(_$SSHConfigImpl) then) =
      __$$SSHConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String host,
      int port,
      String username,
      SSHAuthType authType,
      String? password,
      String? privateKeyPath,
      String? passphrase,
      bool verifyHostKey,
      String? workingDirectory,
      DateTime? lastConnected});
}

/// @nodoc
class __$$SSHConfigImplCopyWithImpl<$Res>
    extends _$SSHConfigCopyWithImpl<$Res, _$SSHConfigImpl>
    implements _$$SSHConfigImplCopyWith<$Res> {
  __$$SSHConfigImplCopyWithImpl(
      _$SSHConfigImpl _value, $Res Function(_$SSHConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? host = null,
    Object? port = null,
    Object? username = null,
    Object? authType = null,
    Object? password = freezed,
    Object? privateKeyPath = freezed,
    Object? passphrase = freezed,
    Object? verifyHostKey = null,
    Object? workingDirectory = freezed,
    Object? lastConnected = freezed,
  }) {
    return _then(_$SSHConfigImpl(
      id: null == id
          ? _value.id
          : id,
      name: null == name
          ? _value.name
          : name,
      host: null == host
          ? _value.host
          : host,
      port: null == port
          ? _value.port
          : port,
      username: null == username
          ? _value.username
          : username,
      authType: null == authType
          ? _value.authType
          : authType,
      password: freezed == password
          ? _value.password
          : password,
      privateKeyPath: freezed == privateKeyPath
          ? _value.privateKeyPath
          : privateKeyPath,
      passphrase: freezed == passphrase
          ? _value.passphrase
          : passphrase,
      verifyHostKey: null == verifyHostKey
          ? _value.verifyHostKey
          : verifyHostKey,
      workingDirectory: freezed == workingDirectory
          ? _value.workingDirectory
          : workingDirectory,
      lastConnected: freezed == lastConnected
          ? _value.lastConnected
          : lastConnected,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SSHConfigImpl implements _SSHConfig {
  const _$SSHConfigImpl(
      {required this.id,
      required this.name,
      required this.host,
      required this.port,
      required this.username,
      required this.authType,
      this.password,
      this.privateKeyPath,
      this.passphrase,
      this.verifyHostKey = true,
      this.workingDirectory,
      this.lastConnected});

  factory _$SSHConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$SSHConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String host;
  @override
  final int port;
  @override
  final String username;
  @override
  final SSHAuthType authType;
  @override
  final String? password;
  @override
  final String? privateKeyPath;
  @override
  final String? passphrase;
  @override
  @JsonKey()
  final bool verifyHostKey;
  @override
  final String? workingDirectory;
  @override
  final DateTime? lastConnected;

  @override
  String toString() {
    return 'SSHConfig(id: $id, name: $name, host: $host, port: $port, username: $username, authType: $authType, password: $password, privateKeyPath: $privateKeyPath, passphrase: $passphrase, verifyHostKey: $verifyHostKey, workingDirectory: $workingDirectory, lastConnected: $lastConnected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SSHConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.authType, authType) ||
                other.authType == authType) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.privateKeyPath, privateKeyPath) ||
                other.privateKeyPath == privateKeyPath) &&
            (identical(other.passphrase, passphrase) ||
                other.passphrase == passphrase) &&
            (identical(other.verifyHostKey, verifyHostKey) ||
                other.verifyHostKey == verifyHostKey) &&
            (identical(other.workingDirectory, workingDirectory) ||
                other.workingDirectory == workingDirectory) &&
            (identical(other.lastConnected, lastConnected) ||
                other.lastConnected == lastConnected));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      host,
      port,
      username,
      authType,
      password,
      privateKeyPath,
      passphrase,
      verifyHostKey,
      workingDirectory,
      lastConnected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SSHConfigImplCopyWith<_$SSHConfigImpl> get copyWith =>
      __$$SSHConfigImplCopyWithImpl<_$SSHConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SSHConfigImplToJson(
      this,
    );
  }
}

abstract class _SSHConfig implements SSHConfig {
  const factory _SSHConfig(
      {required final String id,
      required final String name,
      required final String host,
      required final int port,
      required final String username,
      required final SSHAuthType authType,
      final String? password,
      final String? privateKeyPath,
      final String? passphrase,
      final bool verifyHostKey,
      final String? workingDirectory,
      final DateTime? lastConnected}) = _$SSHConfigImpl;

  factory _SSHConfig.fromJson(Map<String, dynamic> json) =
      _$SSHConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get host;
  @override
  int get port;
  @override
  String get username;
  @override
  SSHAuthType get authType;
  @override
  String? get password;
  @override
  String? get privateKeyPath;
  @override
  String? get passphrase;
  @override
  bool get verifyHostKey;
  @override
  String? get workingDirectory;
  @override
  DateTime? get lastConnected;
  @override
  @JsonKey(ignore: true)
  _$$SSHConfigImplCopyWith<_$SSHConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
