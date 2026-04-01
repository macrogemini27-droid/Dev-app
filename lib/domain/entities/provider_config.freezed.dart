// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProviderConfig _$ProviderConfigFromJson(Map<String, dynamic> json) {
  return _ProviderConfig.fromJson(json);
}

/// @nodoc
mixin _$ProviderConfig {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  ProviderType get type => throw _privateConstructorUsedError;
  String get apiKey => throw _privateConstructorUsedError;
  String? get baseUrl => throw _privateConstructorUsedError;
  String? get customModelName => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProviderConfigCopyWith<ProviderConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProviderConfigCopyWith<$Res> {
  factory $ProviderConfigCopyWith(
          ProviderConfig value, $Res Function(ProviderConfig) then) =
      _$ProviderConfigCopyWithImpl<$Res, ProviderConfig>;
  @useResult
  $Res call(
      {String id,
      String name,
      ProviderType type,
      String apiKey,
      String? baseUrl,
      String? customModelName,
      bool isDefault,
      DateTime? createdAt});
}

/// @nodoc
class _$ProviderConfigCopyWithImpl<$Res, $Val extends ProviderConfig>
    implements $ProviderConfigCopyWith<$Res> {
  _$ProviderConfigCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? apiKey = null,
    Object? baseUrl = freezed,
    Object? customModelName = freezed,
    Object? isDefault = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id,
      name: null == name
          ? _value.name
          : name,
      type: null == type
          ? _value.type
          : type,
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey,
      baseUrl: freezed == baseUrl
          ? _value.baseUrl
          : baseUrl,
      customModelName: freezed == customModelName
          ? _value.customModelName
          : customModelName,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProviderConfigImplCopyWith<$Res>
    implements $ProviderConfigCopyWith<$Res> {
  factory _$$ProviderConfigImplCopyWith(_$ProviderConfigImpl value,
          $Res Function(_$ProviderConfigImpl) then) =
      __$$ProviderConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      ProviderType type,
      String apiKey,
      String? baseUrl,
      String? customModelName,
      bool isDefault,
      DateTime? createdAt});
}

/// @nodoc
class __$$ProviderConfigImplCopyWithImpl<$Res>
    extends _$ProviderConfigCopyWithImpl<$Res, _$ProviderConfigImpl>
    implements _$$ProviderConfigImplCopyWith<$Res> {
  __$$ProviderConfigImplCopyWithImpl(
      _$ProviderConfigImpl _value, $Res Function(_$ProviderConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? apiKey = null,
    Object? baseUrl = freezed,
    Object? customModelName = freezed,
    Object? isDefault = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$ProviderConfigImpl(
      id: null == id
          ? _value.id
          : id,
      name: null == name
          ? _value.name
          : name,
      type: null == type
          ? _value.type
          : type,
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey,
      baseUrl: freezed == baseUrl
          ? _value.baseUrl
          : baseUrl,
      customModelName: freezed == customModelName
          ? _value.customModelName
          : customModelName,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProviderConfigImpl implements _ProviderConfig {
  const _$ProviderConfigImpl(
      {required this.id,
      required this.name,
      required this.type,
      required this.apiKey,
      this.baseUrl,
      this.customModelName,
      this.isDefault = false,
      this.createdAt});

  factory _$ProviderConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProviderConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final ProviderType type;
  @override
  final String apiKey;
  @override
  final String? baseUrl;
  @override
  final String? customModelName;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ProviderConfig(id: $id, name: $name, type: $type, apiKey: $apiKey, baseUrl: $baseUrl, customModelName: $customModelName, isDefault: $isDefault, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProviderConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.customModelName, customModelName) ||
                other.customModelName == customModelName) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, type, apiKey, baseUrl,
      customModelName, isDefault, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProviderConfigImplCopyWith<_$ProviderConfigImpl> get copyWith =>
      __$$ProviderConfigImplCopyWithImpl<_$ProviderConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProviderConfigImplToJson(
      this,
    );
  }
}

abstract class _ProviderConfig implements ProviderConfig {
  const factory _ProviderConfig(
      {required final String id,
      required final String name,
      required final ProviderType type,
      required final String apiKey,
      final String? baseUrl,
      final String? customModelName,
      final bool isDefault,
      final DateTime? createdAt}) = _$ProviderConfigImpl;

  factory _ProviderConfig.fromJson(Map<String, dynamic> json) =
      _$ProviderConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  ProviderType get type;
  @override
  String get apiKey;
  @override
  String? get baseUrl;
  @override
  String? get customModelName;
  @override
  bool get isDefault;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ProviderConfigImplCopyWith<_$ProviderConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
