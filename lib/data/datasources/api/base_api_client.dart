import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/entities/message.dart';
import '../../../domain/entities/provider_config.dart';
import '../../../domain/entities/tool.dart';

/// Base class for all API clients
abstract class BaseApiClient {
  final ProviderConfig config;

  BaseApiClient({
    required this.config,
  });

  /// Stream chat completion with tool support
  Stream<ApiStreamEvent> streamChatCompletion({
    required List<Message> messages,
    required List<Tool> tools,
    String? systemPrompt,
    int? maxTokens,
    double? temperature,
  });

  /// Get the model name to use for API calls
  String getModelName() {
    return config.customModelName ?? config.type.defaultModel;
  }

  /// Get the base URL for API calls
  String getBaseUrl() {
    return config.baseUrl ?? config.type.defaultBaseUrl;
  }

  /// Get common headers for API requests
  Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${config.apiKey}',
    };
  }

  /// Dispose resources
  void dispose() {
    // Override in subclasses to dispose specific resources
  }
}

/// Events emitted during streaming
abstract class ApiStreamEvent {}

class TextChunkEvent extends ApiStreamEvent {
  final String text;
  TextChunkEvent(this.text);
}

class ToolCallEvent extends ApiStreamEvent {
  final String toolCallId;
  final String toolName;
  final Map<String, dynamic> arguments;
  
  ToolCallEvent({
    required this.toolCallId,
    required this.toolName,
    required this.arguments,
  });
}

class StreamEndEvent extends ApiStreamEvent {
  final String? stopReason;
  final Map<String, dynamic>? usage;
  
  StreamEndEvent({this.stopReason, this.usage});
}

class StreamErrorEvent extends ApiStreamEvent {
  final String error;
  final dynamic details;
  
  StreamErrorEvent(this.error, [this.details]);
}
