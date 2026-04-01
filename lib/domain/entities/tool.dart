import 'package:freezed_annotation/freezed_annotation.dart';

part 'tool.freezed.dart';
part 'tool.g.dart';

@freezed
class Tool with _$Tool {
  const factory Tool({
    required String name,
    required String description,
    required Map<String, dynamic> parameters,
    @Default([]) List<String> aliases,
    @Default(false) bool isReadOnly,
    @Default(true) bool isConcurrencySafe,
  }) = _Tool;

  factory Tool.fromJson(Map<String, dynamic> json) => _$ToolFromJson(json);
}

@freezed
class ToolCall with _$ToolCall {
  const factory ToolCall({
    required String id,
    required String name,
    required Map<String, dynamic> arguments,
  }) = _ToolCall;

  factory ToolCall.fromJson(Map<String, dynamic> json) => _$ToolCallFromJson(json);
}

@freezed
class ToolExecutionParams with _$ToolExecutionParams {
  const factory ToolExecutionParams({
    required String toolName,
    required Map<String, dynamic> arguments,
  }) = _ToolExecutionParams;

  factory ToolExecutionParams.fromJson(Map<String, dynamic> json) =>
      _$ToolExecutionParamsFromJson(json);
}

@freezed
class ToolExecutionContext with _$ToolExecutionContext {
  const factory ToolExecutionContext({
    required String sessionId,
    required String workingDirectory,
    required Map<String, dynamic> environment,
  }) = _ToolExecutionContext;

  factory ToolExecutionContext.fromJson(Map<String, dynamic> json) =>
      _$ToolExecutionContextFromJson(json);
}
