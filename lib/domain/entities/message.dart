import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String sessionId,
    required MessageRole role,
    required String content,
    required DateTime timestamp,
    List<ToolCall>? toolCalls,
    List<ToolResult>? toolResults,
    MessageStatus? status,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

enum MessageRole {
  user,
  assistant,
  system,
}

enum MessageStatus {
  sending,
  sent,
  streaming,
  completed,
  error,
}

@freezed
class ToolCall with _$ToolCall {
  const factory ToolCall({
    required String id,
    required String name,
    required Map<String, dynamic> input,
    ToolCallStatus? status,
    DateTime? startedAt,
    DateTime? completedAt,
  }) = _ToolCall;

  factory ToolCall.fromJson(Map<String, dynamic> json) =>
      _$ToolCallFromJson(json);
}

enum ToolCallStatus {
  queued,
  running,
  completed,
  failed,
}

@freezed
class ToolResult with _$ToolResult {
  const factory ToolResult({
    required String toolCallId,
    required String content,
    @Default(false) bool isError,
    DateTime? timestamp,
  }) = _ToolResult;

  factory ToolResult.fromJson(Map<String, dynamic> json) =>
      _$ToolResultFromJson(json);
}
