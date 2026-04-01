// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tool.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ToolImpl _$$ToolImplFromJson(Map<String, dynamic> json) => _$ToolImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      parameters: json['parameters'] as Map<String, dynamic>,
      aliases: (json['aliases'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isReadOnly: json['isReadOnly'] as bool? ?? false,
      isConcurrencySafe: json['isConcurrencySafe'] as bool? ?? true,
    );

Map<String, dynamic> _$$ToolImplToJson(_$ToolImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'parameters': instance.parameters,
      'aliases': instance.aliases,
      'isReadOnly': instance.isReadOnly,
      'isConcurrencySafe': instance.isConcurrencySafe,
    };

_$ToolCallImpl _$$ToolCallImplFromJson(Map<String, dynamic> json) =>
    _$ToolCallImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      arguments: json['arguments'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$ToolCallImplToJson(_$ToolCallImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'arguments': instance.arguments,
    };

_$ToolExecutionParamsImpl _$$ToolExecutionParamsImplFromJson(
        Map<String, dynamic> json) =>
    _$ToolExecutionParamsImpl(
      toolName: json['toolName'] as String,
      arguments: json['arguments'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$ToolExecutionParamsImplToJson(
        _$ToolExecutionParamsImpl instance) =>
    <String, dynamic>{
      'toolName': instance.toolName,
      'arguments': instance.arguments,
    };

_$ToolExecutionContextImpl _$$ToolExecutionContextImplFromJson(
        Map<String, dynamic> json) =>
    _$ToolExecutionContextImpl(
      sessionId: json['sessionId'] as String,
      workingDirectory: json['workingDirectory'] as String,
      environment: json['environment'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$ToolExecutionContextImplToJson(
        _$ToolExecutionContextImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'workingDirectory': instance.workingDirectory,
      'environment': instance.environment,
    };
