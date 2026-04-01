import 'package:freezed_annotation/freezed_annotation.dart';

part 'tool.freezed.dart';
part 'tool.g.dart';

@freezed
class Tool with _$Tool {
  const factory Tool({
    required String name,
    required String description,
    required Map<String, dynamic> inputSchema,
    @Default([]) List<String> aliases,
    @Default(false) bool isReadOnly,
    @Default(true) bool isConcurrencySafe,
  }) = _Tool;

  factory Tool.fromJson(Map<String, dynamic> json) => _$ToolFromJson(json);
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
