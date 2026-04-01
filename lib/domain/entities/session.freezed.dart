// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Session _$SessionFromJson(Map<String, dynamic> json) {
  return _Session.fromJson(json);
}

/// @nodoc
mixin _$Session {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get sshConfigId => throw _privateConstructorUsedError;
  String get providerId => throw _privateConstructorUsedError;
  String get workingDirectory => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<Message> get messages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SessionCopyWith<Session> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionCopyWith<$Res> {
  factory $SessionCopyWith(Session value, $Res Function(Session) then) =
      _$SessionCopyWithImpl<$Res, Session>;
  @useResult
  $Res call(
      {String id,
      String name,
      String sshConfigId,
      String providerId,
      String workingDirectory,
      DateTime createdAt,
      DateTime? updatedAt,
      List<Message> messages});
}

/// @nodoc
class _$SessionCopyWithImpl<$Res, $Val extends Session>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? sshConfigId = null,
    Object? providerId = null,
    Object? workingDirectory = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? messages = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id,
      name: null == name
          ? _value.name
          : name,
      sshConfigId: null == sshConfigId
          ? _value.sshConfigId
          : sshConfigId,
      providerId: null == providerId
          ? _value.providerId
          : providerId,
      workingDirectory: null == workingDirectory
          ? _value.workingDirectory
          : workingDirectory,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt,
      messages: null == messages
          ? _value.messages
          : messages,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionImplCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$$SessionImplCopyWith(
          _$SessionImpl value, $Res Function(_$SessionImpl) then) =
      __$$SessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String sshConfigId,
      String providerId,
      String workingDirectory,
      DateTime createdAt,
      DateTime? updatedAt,
      List<Message> messages});
}

/// @nodoc
class __$$SessionImplCopyWithImpl<$Res>
    extends _$SessionCopyWithImpl<$Res, _$SessionImpl>
    implements _$$SessionImplCopyWith<$Res> {
  __$$SessionImplCopyWithImpl(
      _$SessionImpl _value, $Res Function(_$SessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? sshConfigId = null,
    Object? providerId = null,
    Object? workingDirectory = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? messages = null,
  }) {
    return _then(_$SessionImpl(
      id: null == id
          ? _value.id
          : id,
      name: null == name
          ? _value.name
          : name,
      sshConfigId: null == sshConfigId
          ? _value.sshConfigId
          : sshConfigId,
      providerId: null == providerId
          ? _value.providerId
          : providerId,
      workingDirectory: null == workingDirectory
          ? _value.workingDirectory
          : workingDirectory,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt,
      messages: null == messages
          ? _value._messages
          : messages,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionImpl implements _Session {
  const _$SessionImpl(
      {required this.id,
      required this.name,
      required this.sshConfigId,
      required this.providerId,
      required this.workingDirectory,
      required this.createdAt,
      this.updatedAt,
      final List<Message> messages = const []})
      : _messages = messages;

  factory _$SessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String sshConfigId;
  @override
  final String providerId;
  @override
  final String workingDirectory;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  final List<Message> _messages;
  @override
  @JsonKey()
  List<Message> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    return EqualUnmodifiableListView(_messages);
  }

  @override
  String toString() {
    return 'Session(id: $id, name: $name, sshConfigId: $sshConfigId, providerId: $providerId, workingDirectory: $workingDirectory, createdAt: $createdAt, updatedAt: $updatedAt, messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sshConfigId, sshConfigId) ||
                other.sshConfigId == sshConfigId) &&
            (identical(other.providerId, providerId) ||
                other.providerId == providerId) &&
            (identical(other.workingDirectory, workingDirectory) ||
                other.workingDirectory == workingDirectory) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      sshConfigId,
      providerId,
      workingDirectory,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_messages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionImplCopyWith<_$SessionImpl> get copyWith =>
      __$$SessionImplCopyWithImpl<_$SessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionImplToJson(
      this,
    );
  }
}

abstract class _Session implements Session {
  const factory _Session(
      {required final String id,
      required final String name,
      required final String sshConfigId,
      required final String providerId,
      required final String workingDirectory,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final List<Message> messages}) = _$SessionImpl;

  factory _Session.fromJson(Map<String, dynamic> json) =
      _$SessionImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get sshConfigId;
  @override
  String get providerId;
  @override
  String get workingDirectory;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  List<Message> get messages;
  @override
  @JsonKey(ignore: true)
  _$$SessionImplCopyWith<_$SessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
