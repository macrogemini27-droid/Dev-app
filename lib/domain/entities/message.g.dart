// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      role: $enumDecode(_$MessageRoleEnumMap, json['role']),
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      toolCalls: (json['toolCalls'] as List<dynamic>?)
          ?.map((e) => ToolCall.fromJson(e as Map<String, dynamic>))
          .toList(),
      toolResults: (json['toolResults'] as List<dynamic>?)
          ?.map((e) => ToolResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'role': _$MessageRoleEnumMap[instance.role]!,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
      'toolCalls': instance.toolCalls,
      'toolResults': instance.toolResults,
      'status': _$MessageStatusEnumMap[instance.status],
    };

const _$MessageRoleEnumMap = {
  MessageRole.user: 'user',
  MessageRole.assistant: 'assistant',
  MessageRole.system: 'system',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.streaming: 'streaming',
  MessageStatus.completed: 'completed',
  MessageStatus.error: 'error',
};

_$ToolCallImpl _$$ToolCallImplFromJson(Map<String, dynamic> json) =>
    _$ToolCallImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      input: json['input'] as Map<String, dynamic>,
      status: $enumDecodeNullable(_$ToolCallStatusEnumMap, json['status']),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$ToolCallImplToJson(_$ToolCallImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'input': instance.input,
      'status': _$ToolCallStatusEnumMap[instance.status],
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$ToolCallStatusEnumMap = {
  ToolCallStatus.queued: 'queued',
  ToolCallStatus.running: 'running',
  ToolCallStatus.completed: 'completed',
  ToolCallStatus.failed: 'failed',
};

_$ToolResultImpl _$$ToolResultImplFromJson(Map<String, dynamic> json) =>
    _$ToolResultImpl(
      toolCallId: json['toolCallId'] as String,
      content: json['content'] as String,
      isError: json['isError'] as bool? ?? false,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ToolResultImplToJson(_$ToolResultImpl instance) =>
    <String, dynamic>{
      'toolCallId': instance.toolCallId,
      'content': instance.content,
      'isError': instance.isError,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
