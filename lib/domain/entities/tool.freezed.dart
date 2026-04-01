// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tool.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Tool _$ToolFromJson(Map<String, dynamic> json) {
  return _Tool.fromJson(json);
}

/// @nodoc
mixin _$Tool {
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  Map<String, dynamic> get parameters => throw _privateConstructorUsedError;
  List<String> get aliases => throw _privateConstructorUsedError;
  bool get isReadOnly => throw _privateConstructorUsedError;
  bool get isConcurrencySafe => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolCopyWith<Tool> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolCopyWith<$Res> {
  factory $ToolCopyWith(Tool value, $Res Function(Tool) then) =
      _$ToolCopyWithImpl<$Res, Tool>;
  @useResult
  $Res call(
      {String name,
      String description,
      Map<String, dynamic> parameters,
      List<String> aliases,
      bool isReadOnly,
      bool isConcurrencySafe});
}

/// @nodoc
class _$ToolCopyWithImpl<$Res, $Val extends Tool>
    implements $ToolCopyWith<$Res> {
  _$ToolCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? parameters = null,
    Object? aliases = null,
    Object? isReadOnly = null,
    Object? isConcurrencySafe = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name,
      description: null == description
          ? _value.description
          : description,
      parameters: null == parameters
          ? _value.parameters
          : parameters,
      aliases: null == aliases
          ? _value.aliases
          : aliases,
      isReadOnly: null == isReadOnly
          ? _value.isReadOnly
          : isReadOnly,
      isConcurrencySafe: null == isConcurrencySafe
          ? _value.isConcurrencySafe
          : isConcurrencySafe,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ToolImplCopyWith<$Res> implements $ToolCopyWith<$Res> {
  factory _$$ToolImplCopyWith(
          _$ToolImpl value, $Res Function(_$ToolImpl) then) =
      __$$ToolImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String description,
      Map<String, dynamic> parameters,
      List<String> aliases,
      bool isReadOnly,
      bool isConcurrencySafe});
}

/// @nodoc
class __$$ToolImplCopyWithImpl<$Res>
    extends _$ToolCopyWithImpl<$Res, _$ToolImpl>
    implements _$$ToolImplCopyWith<$Res> {
  __$$ToolImplCopyWithImpl(_$ToolImpl _value, $Res Function(_$ToolImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? parameters = null,
    Object? aliases = null,
    Object? isReadOnly = null,
    Object? isConcurrencySafe = null,
  }) {
    return _then(_$ToolImpl(
      name: null == name
          ? _value.name
          : name,
      description: null == description
          ? _value.description
          : description,
      parameters: null == parameters
          ? _value.parameters
          : parameters,
      aliases: null == aliases
          ? _value.aliases
          : aliases,
      isReadOnly: null == isReadOnly
          ? _value.isReadOnly
          : isReadOnly,
      isConcurrencySafe: null == isConcurrencySafe
          ? _value.isConcurrencySafe
          : isConcurrencySafe,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolImpl implements _Tool {
  const _$ToolImpl(
      {required this.name,
      required this.description,
      required this.parameters,
      this.aliases = const [],
      this.isReadOnly = false,
      this.isConcurrencySafe = true});

  factory _$ToolImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolImplFromJson(json);

  @override
  final String name;
  @override
  final String description;
  @override
  final Map<String, dynamic> parameters;
  @override
  @JsonKey()
  final List<String> aliases;
  @override
  @JsonKey()
  final bool isReadOnly;
  @override
  @JsonKey()
  final bool isConcurrencySafe;

  @override
  String toString() {
    return 'Tool(name: $name, description: $description, parameters: $parameters, aliases: $aliases, isReadOnly: $isReadOnly, isConcurrencySafe: $isConcurrencySafe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other.parameters, parameters) &&
            const DeepCollectionEquality().equals(other.aliases, aliases) &&
            (identical(other.isReadOnly, isReadOnly) ||
                other.isReadOnly == isReadOnly) &&
            (identical(other.isConcurrencySafe, isConcurrencySafe) ||
                other.isConcurrencySafe == isConcurrencySafe));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      description,
      const DeepCollectionEquality().hash(parameters),
      const DeepCollectionEquality().hash(aliases),
      isReadOnly,
      isConcurrencySafe);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolImplCopyWith<_$ToolImpl> get copyWith =>
      __$$ToolImplCopyWithImpl<_$ToolImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolImplToJson(
      this,
    );
  }
}

abstract class _Tool implements Tool {
  const factory _Tool(
      {required final String name,
      required final String description,
      required final Map<String, dynamic> parameters,
      final List<String> aliases,
      final bool isReadOnly,
      final bool isConcurrencySafe}) = _$ToolImpl;

  factory _Tool.fromJson(Map<String, dynamic> json) = _$ToolImpl.fromJson;

  @override
  String get name;
  @override
  String get description;
  @override
  Map<String, dynamic> get parameters;
  @override
  List<String> get aliases;
  @override
  bool get isReadOnly;
  @override
  bool get isConcurrencySafe;
  @override
  @JsonKey(ignore: true)
  _$$ToolImplCopyWith<_$ToolImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// **************************************************************************
// ToolExecutionParams
// **************************************************************************

ToolExecutionParams _$ToolExecutionParamsFromJson(Map<String, dynamic> json) {
  return _ToolExecutionParams.fromJson(json);
}

/// @nodoc
mixin _$ToolExecutionParams {
  String get toolName => throw _privateConstructorUsedError;
  Map<String, dynamic> get arguments => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolExecutionParamsCopyWith<ToolExecutionParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolExecutionParamsCopyWith<$Res> {
  factory $ToolExecutionParamsCopyWith(ToolExecutionParams value,
          $Res Function(ToolExecutionParams) then) =
      _$ToolExecutionParamsCopyWithImpl<$Res, ToolExecutionParams>;
  @useResult
  $Res call({String toolName, Map<String, dynamic> arguments});
}

/// @nodoc
class _$ToolExecutionParamsCopyWithImpl<$Res,
        $Val extends ToolExecutionParams>
    implements $ToolExecutionParamsCopyWith<$Res> {
  _$ToolExecutionParamsCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toolName = null,
    Object? arguments = null,
  }) {
    return _then(_value.copyWith(
      toolName: null == toolName ? _value.toolName : toolName,
      arguments: null == arguments ? _value.arguments : arguments,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ToolExecutionParamsImplCopyWith<$Res>
    implements $ToolExecutionParamsCopyWith<$Res> {
  factory _$$ToolExecutionParamsImplCopyWith(_$ToolExecutionParamsImpl value,
          $Res Function(_$ToolExecutionParamsImpl) then) =
      __$$ToolExecutionParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String toolName, Map<String, dynamic> arguments});
}

/// @nodoc
class __$$ToolExecutionParamsImplCopyWithImpl<$Res>
    extends _$ToolExecutionParamsCopyWithImpl<$Res, _$ToolExecutionParamsImpl>
    implements _$$ToolExecutionParamsImplCopyWith<$Res> {
  __$$ToolExecutionParamsImplCopyWithImpl(_$ToolExecutionParamsImpl _value,
      $Res Function(_$ToolExecutionParamsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toolName = null,
    Object? arguments = null,
  }) {
    return _then(_$ToolExecutionParamsImpl(
      toolName: null == toolName ? _value.toolName : toolName,
      arguments: null == arguments ? _value.arguments : arguments,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolExecutionParamsImpl implements _ToolExecutionParams {
  const _$ToolExecutionParamsImpl(
      {required this.toolName, required this.arguments});

  factory _$ToolExecutionParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolExecutionParamsImplFromJson(json);

  @override
  final String toolName;
  @override
  final Map<String, dynamic> arguments;

  @override
  String toString() {
    return 'ToolExecutionParams(toolName: $toolName, arguments: $arguments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolExecutionParamsImpl &&
            (identical(other.toolName, toolName) ||
                other.toolName == toolName) &&
            const DeepCollectionEquality().equals(other.arguments, arguments));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, toolName, const DeepCollectionEquality().hash(arguments));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolExecutionParamsImplCopyWith<_$ToolExecutionParamsImpl> get copyWith =>
      __$$ToolExecutionParamsImplCopyWithImpl<_$ToolExecutionParamsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolExecutionParamsImplToJson(
      this,
    );
  }
}

abstract class _ToolExecutionParams implements ToolExecutionParams {
  const factory _ToolExecutionParams(
          {required final String toolName,
          required final Map<String, dynamic> arguments}) =
      _$ToolExecutionParamsImpl;

  factory _ToolExecutionParams.fromJson(Map<String, dynamic> json) =
      _$ToolExecutionParamsImpl.fromJson;

  @override
  String get toolName;
  @override
  Map<String, dynamic> get arguments;
  @override
  @JsonKey(ignore: true)
  _$$ToolExecutionParamsImplCopyWith<_$ToolExecutionParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// **************************************************************************
// ToolExecutionContext
// **************************************************************************

ToolExecutionContext _$ToolExecutionContextFromJson(
    Map<String, dynamic> json) {
  return _ToolExecutionContext.fromJson(json);
}

/// @nodoc
mixin _$ToolExecutionContext {
  String get sessionId => throw _privateConstructorUsedError;
  String get workingDirectory => throw _privateConstructorUsedError;
  Map<String, dynamic> get environment => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolExecutionContextCopyWith<ToolExecutionContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolExecutionContextCopyWith<$Res> {
  factory $ToolExecutionContextCopyWith(ToolExecutionContext value,
          $Res Function(ToolExecutionContext) then) =
      _$ToolExecutionContextCopyWithImpl<$Res, ToolExecutionContext>;
  @useResult
  $Res call(
      {String sessionId,
      String workingDirectory,
      Map<String, dynamic> environment});
}

/// @nodoc
class _$ToolExecutionContextCopyWithImpl<$Res,
        $Val extends ToolExecutionContext>
    implements $ToolExecutionContextCopyWith<$Res> {
  _$ToolExecutionContextCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? workingDirectory = null,
    Object? environment = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId ? _value.sessionId : sessionId,
      workingDirectory: null == workingDirectory
          ? _value.workingDirectory
          : workingDirectory,
      environment: null == environment ? _value.environment : environment,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ToolExecutionContextImplCopyWith<$Res>
    implements $ToolExecutionContextCopyWith<$Res> {
  factory _$$ToolExecutionContextImplCopyWith(
          _$ToolExecutionContextImpl value,
          $Res Function(_$ToolExecutionContextImpl) then) =
      __$$ToolExecutionContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String workingDirectory,
      Map<String, dynamic> environment});
}

/// @nodoc
class __$$ToolExecutionContextImplCopyWithImpl<$Res>
    extends _$ToolExecutionContextCopyWithImpl<$Res,
        _$ToolExecutionContextImpl>
    implements _$$ToolExecutionContextImplCopyWith<$Res> {
  __$$ToolExecutionContextImplCopyWithImpl(_$ToolExecutionContextImpl _value,
      $Res Function(_$ToolExecutionContextImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? workingDirectory = null,
    Object? environment = null,
  }) {
    return _then(_$ToolExecutionContextImpl(
      sessionId: null == sessionId ? _value.sessionId : sessionId,
      workingDirectory: null == workingDirectory
          ? _value.workingDirectory
          : workingDirectory,
      environment: null == environment ? _value.environment : environment,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolExecutionContextImpl implements _ToolExecutionContext {
  const _$ToolExecutionContextImpl(
      {required this.sessionId,
      required this.workingDirectory,
      required this.environment});

  factory _$ToolExecutionContextImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolExecutionContextImplFromJson(json);

  @override
  final String sessionId;
  @override
  final String workingDirectory;
  @override
  final Map<String, dynamic> environment;

  @override
  String toString() {
    return 'ToolExecutionContext(sessionId: $sessionId, workingDirectory: $workingDirectory, environment: $environment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolExecutionContextImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.workingDirectory, workingDirectory) ||
                other.workingDirectory == workingDirectory) &&
            const DeepCollectionEquality()
                .equals(other.environment, environment));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sessionId, workingDirectory,
      const DeepCollectionEquality().hash(environment));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolExecutionContextImplCopyWith<_$ToolExecutionContextImpl>
      get copyWith => __$$ToolExecutionContextImplCopyWithImpl<
          _$ToolExecutionContextImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolExecutionContextImplToJson(
      this,
    );
  }
}

abstract class _ToolExecutionContext implements ToolExecutionContext {
  const factory _ToolExecutionContext(
          {required final String sessionId,
          required final String workingDirectory,
          required final Map<String, dynamic> environment}) =
      _$ToolExecutionContextImpl;

  factory _ToolExecutionContext.fromJson(Map<String, dynamic> json) =
      _$ToolExecutionContextImpl.fromJson;

  @override
  String get sessionId;
  @override
  String get workingDirectory;
  @override
  Map<String, dynamic> get environment;
  @override
  @JsonKey(ignore: true)
  _$$ToolExecutionContextImplCopyWith<_$ToolExecutionContextImpl>
      get copyWith => throw _privateConstructorUsedError;
}
