// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Message _$MessageFromJson(Map<String, dynamic> json) {
  return _Message.fromJson(json);
}

/// @nodoc
mixin _$Message {
  String get id => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  MessageRole get role => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  List<ToolCall>? get toolCalls => throw _privateConstructorUsedError;
  List<ToolResult>? get toolResults => throw _privateConstructorUsedError;
  MessageStatus? get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call(
      {String id,
      String sessionId,
      MessageRole role,
      String content,
      DateTime timestamp,
      List<ToolCall>? toolCalls,
      List<ToolResult>? toolResults,
      MessageStatus? status});
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? role = null,
    Object? content = null,
    Object? timestamp = null,
    Object? toolCalls = freezed,
    Object? toolResults = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId,
      role: null == role
          ? _value.role
          : role,
      content: null == content
          ? _value.content
          : content,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp,
      toolCalls: freezed == toolCalls
          ? _value.toolCalls
          : toolCalls,
      toolResults: freezed == toolResults
          ? _value.toolResults
          : toolResults,
      status: freezed == status
          ? _value.status
          : status,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
          _$MessageImpl value, $Res Function(_$MessageImpl) then) =
      __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sessionId,
      MessageRole role,
      String content,
      DateTime timestamp,
      List<ToolCall>? toolCalls,
      List<ToolResult>? toolResults,
      MessageStatus? status});
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
      _$MessageImpl _value, $Res Function(_$MessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? role = null,
    Object? content = null,
    Object? timestamp = null,
    Object? toolCalls = freezed,
    Object? toolResults = freezed,
    Object? status = freezed,
  }) {
    return _then(_$MessageImpl(
      id: null == id
          ? _value.id
          : id,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId,
      role: null == role
          ? _value.role
          : role,
      content: null == content
          ? _value.content
          : content,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp,
      toolCalls: freezed == toolCalls
          ? _value._toolCalls
          : toolCalls,
      toolResults: freezed == toolResults
          ? _value._toolResults
          : toolResults,
      status: freezed == status
          ? _value.status
          : status,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageImpl implements _Message {
  const _$MessageImpl(
      {required this.id,
      required this.sessionId,
      required this.role,
      required this.content,
      required this.timestamp,
      final List<ToolCall>? toolCalls,
      final List<ToolResult>? toolResults,
      this.status})
      : _toolCalls = toolCalls,
        _toolResults = toolResults;

  factory _$MessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageImplFromJson(json);

  @override
  final String id;
  @override
  final String sessionId;
  @override
  final MessageRole role;
  @override
  final String content;
  @override
  final DateTime timestamp;
  final List<ToolCall>? _toolCalls;
  @override
  List<ToolCall>? get toolCalls {
    final value = _toolCalls;
    if (value == null) return null;
    if (_toolCalls is EqualUnmodifiableListView) return _toolCalls;
    return EqualUnmodifiableListView(value);
  }

  final List<ToolResult>? _toolResults;
  @override
  List<ToolResult>? get toolResults {
    final value = _toolResults;
    if (value == null) return null;
    if (_toolResults is EqualUnmodifiableListView) return _toolResults;
    return EqualUnmodifiableListView(value);
  }

  @override
  final MessageStatus? status;

  @override
  String toString() {
    return 'Message(id: $id, sessionId: $sessionId, role: $role, content: $content, timestamp: $timestamp, toolCalls: $toolCalls, toolResults: $toolResults, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality()
                .equals(other._toolCalls, _toolCalls) &&
            const DeepCollectionEquality()
                .equals(other._toolResults, _toolResults) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sessionId,
      role,
      content,
      timestamp,
      const DeepCollectionEquality().hash(_toolCalls),
      const DeepCollectionEquality().hash(_toolResults),
      status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageImplToJson(
      this,
    );
  }
}

abstract class _Message implements Message {
  const factory _Message(
      {required final String id,
      required final String sessionId,
      required final MessageRole role,
      required final String content,
      required final DateTime timestamp,
      final List<ToolCall>? toolCalls,
      final List<ToolResult>? toolResults,
      final MessageStatus? status}) = _$MessageImpl;

  factory _Message.fromJson(Map<String, dynamic> json) =
      _$MessageImpl.fromJson;

  @override
  String get id;
  @override
  String get sessionId;
  @override
  MessageRole get role;
  @override
  String get content;
  @override
  DateTime get timestamp;
  @override
  List<ToolCall>? get toolCalls;
  @override
  List<ToolResult>? get toolResults;
  @override
  MessageStatus? get status;
  @override
  @JsonKey(ignore: true)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// **************************************************************************
// ToolCall
// **************************************************************************

ToolCall _$ToolCallFromJson(Map<String, dynamic> json) {
  return _ToolCall.fromJson(json);
}

/// @nodoc
mixin _$ToolCall {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Map<String, dynamic> get input => throw _privateConstructorUsedError;
  ToolCallStatus? get status => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolCallCopyWith<ToolCall> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolCallCopyWith<$Res> {
  factory $ToolCallCopyWith(ToolCall value, $Res Function(ToolCall) then) =
      _$ToolCallCopyWithImpl<$Res, ToolCall>;
  @useResult
  $Res call(
      {String id,
      String name,
      Map<String, dynamic> input,
      ToolCallStatus? status,
      DateTime? startedAt,
      DateTime? completedAt});
}

/// @nodoc
class _$ToolCallCopyWithImpl<$Res, $Val extends ToolCall>
    implements $ToolCallCopyWith<$Res> {
  _$ToolCallCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? input = null,
    Object? status = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id,
      name: null == name
          ? _value.name
          : name,
      input: null == input
          ? _value.input
          : input,
      status: freezed == status
          ? _value.status
          : status,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ToolCallImplCopyWith<$Res>
    implements $ToolCallCopyWith<$Res> {
  factory _$$ToolCallImplCopyWith(
          _$ToolCallImpl value, $Res Function(_$ToolCallImpl) then) =
      __$$ToolCallImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      Map<String, dynamic> input,
      ToolCallStatus? status,
      DateTime? startedAt,
      DateTime? completedAt});
}

/// @nodoc
class __$$ToolCallImplCopyWithImpl<$Res>
    extends _$ToolCallCopyWithImpl<$Res, _$ToolCallImpl>
    implements _$$ToolCallImplCopyWith<$Res> {
  __$$ToolCallImplCopyWithImpl(
      _$ToolCallImpl _value, $Res Function(_$ToolCallImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? input = null,
    Object? status = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$ToolCallImpl(
      id: null == id
          ? _value.id
          : id,
      name: null == name
          ? _value.name
          : name,
      input: null == input
          ? _value._input
          : input,
      status: freezed == status
          ? _value.status
          : status,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolCallImpl implements _ToolCall {
  const _$ToolCallImpl(
      {required this.id,
      required this.name,
      required final Map<String, dynamic> input,
      this.status,
      this.startedAt,
      this.completedAt})
      : _input = input;

  factory _$ToolCallImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolCallImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final Map<String, dynamic> _input;
  @override
  Map<String, dynamic> get input {
    if (_input is EqualUnmodifiableMapView) return _input;
    return EqualUnmodifiableMapView(_input);
  }

  @override
  final ToolCallStatus? status;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'ToolCall(id: $id, name: $name, input: $input, status: $status, startedAt: $startedAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolCallImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._input, _input) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      const DeepCollectionEquality().hash(_input),
      status,
      startedAt,
      completedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolCallImplCopyWith<_$ToolCallImpl> get copyWith =>
      __$$ToolCallImplCopyWithImpl<_$ToolCallImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolCallImplToJson(
      this,
    );
  }
}

abstract class _ToolCall implements ToolCall {
  const factory _ToolCall(
      {required final String id,
      required final String name,
      required final Map<String, dynamic> input,
      final ToolCallStatus? status,
      final DateTime? startedAt,
      final DateTime? completedAt}) = _$ToolCallImpl;

  factory _ToolCall.fromJson(Map<String, dynamic> json) =
      _$ToolCallImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  Map<String, dynamic> get input;
  @override
  ToolCallStatus? get status;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get completedAt;
  @override
  @JsonKey(ignore: true)
  _$$ToolCallImplCopyWith<_$ToolCallImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// **************************************************************************
// ToolResult
// **************************************************************************

ToolResult _$ToolResultFromJson(Map<String, dynamic> json) {
  return _ToolResult.fromJson(json);
}

/// @nodoc
mixin _$ToolResult {
  String get toolCallId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  bool get isError => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolResultCopyWith<ToolResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolResultCopyWith<$Res> {
  factory $ToolResultCopyWith(
          ToolResult value, $Res Function(ToolResult) then) =
      _$ToolResultCopyWithImpl<$Res, ToolResult>;
  @useResult
  $Res call(
      {String toolCallId, String content, bool isError, DateTime? timestamp});
}

/// @nodoc
class _$ToolResultCopyWithImpl<$Res, $Val extends ToolResult>
    implements $ToolResultCopyWith<$Res> {
  _$ToolResultCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toolCallId = null,
    Object? content = null,
    Object? isError = null,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      toolCallId: null == toolCallId
          ? _value.toolCallId
          : toolCallId,
      content: null == content
          ? _value.content
          : content,
      isError: null == isError
          ? _value.isError
          : isError,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ToolResultImplCopyWith<$Res>
    implements $ToolResultCopyWith<$Res> {
  factory _$$ToolResultImplCopyWith(
          _$ToolResultImpl value, $Res Function(_$ToolResultImpl) then) =
      __$$ToolResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String toolCallId, String content, bool isError, DateTime? timestamp});
}

/// @nodoc
class __$$ToolResultImplCopyWithImpl<$Res>
    extends _$ToolResultCopyWithImpl<$Res, _$ToolResultImpl>
    implements _$$ToolResultImplCopyWith<$Res> {
  __$$ToolResultImplCopyWithImpl(
      _$ToolResultImpl _value, $Res Function(_$ToolResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toolCallId = null,
    Object? content = null,
    Object? isError = null,
    Object? timestamp = freezed,
  }) {
    return _then(_$ToolResultImpl(
      toolCallId: null == toolCallId
          ? _value.toolCallId
          : toolCallId,
      content: null == content
          ? _value.content
          : content,
      isError: null == isError
          ? _value.isError
          : isError,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolResultImpl implements _ToolResult {
  const _$ToolResultImpl(
      {required this.toolCallId,
      required this.content,
      this.isError = false,
      this.timestamp});

  factory _$ToolResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolResultImplFromJson(json);

  @override
  final String toolCallId;
  @override
  final String content;
  @override
  @JsonKey()
  final bool isError;
  @override
  final DateTime? timestamp;

  @override
  String toString() {
    return 'ToolResult(toolCallId: $toolCallId, content: $content, isError: $isError, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolResultImpl &&
            (identical(other.toolCallId, toolCallId) ||
                other.toolCallId == toolCallId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isError, isError) || other.isError == isError) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, toolCallId, content, isError, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolResultImplCopyWith<_$ToolResultImpl> get copyWith =>
      __$$ToolResultImplCopyWithImpl<_$ToolResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolResultImplToJson(
      this,
    );
  }
}

abstract class _ToolResult implements ToolResult {
  const factory _ToolResult(
      {required final String toolCallId,
      required final String content,
      final bool isError,
      final DateTime? timestamp}) = _$ToolResultImpl;

  factory _ToolResult.fromJson(Map<String, dynamic> json) =
      _$ToolResultImpl.fromJson;

  @override
  String get toolCallId;
  @override
  String get content;
  @override
  bool get isError;
  @override
  DateTime? get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$ToolResultImplCopyWith<_$ToolResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
