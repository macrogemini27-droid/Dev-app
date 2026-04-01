// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProviderConfigImpl _$$ProviderConfigImplFromJson(Map<String, dynamic> json) =>
    _$ProviderConfigImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$ProviderTypeEnumMap, json['type']),
      apiKey: json['apiKey'] as String,
      baseUrl: json['baseUrl'] as String?,
      customModelName: json['customModelName'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ProviderConfigImplToJson(
        _$ProviderConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$ProviderTypeEnumMap[instance.type]!,
      'apiKey': instance.apiKey,
      'baseUrl': instance.baseUrl,
      'customModelName': instance.customModelName,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$ProviderTypeEnumMap = {
  ProviderType.anthropic: 'anthropic',
  ProviderType.gemini: 'gemini',
  ProviderType.groq: 'groq',
  ProviderType.bedrock: 'bedrock',
  ProviderType.vertex: 'vertex',
  ProviderType.custom: 'custom',
};
