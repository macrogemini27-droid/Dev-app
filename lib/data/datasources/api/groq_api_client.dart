import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../domain/entities/provider_config.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/entities/tool.dart';
import 'base_api_client.dart';

class GroqApiClient extends BaseApiClient {
  late final Dio _dio;

  GroqApiClient({
    required super.config,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: getBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 120),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${config.apiKey}',
        },
      ),
    );
  }

  @override
  Stream<ApiStreamEvent> streamChatCompletion({
    required List<Message> messages,
    required List<Tool> tools,
    String? systemPrompt,
    int? maxTokens,
    double? temperature,
  }) async* {
    try {
      final response = await _dio.post(
        '/chat/completions',
        options: Options(
          responseType: ResponseType.stream,
        ),
        data: {
          'model': getModelName(),
          'messages': _convertMessages(messages, systemPrompt),
          if (tools.isNotEmpty) 'tools': _convertTools(tools),
          if (maxTokens != null) 'max_tokens': maxTokens,
          if (temperature != null) 'temperature': temperature,
          'stream': true,
        },
      );

      final stream = response.data.stream;
      String buffer = '';
      
      await for (final chunk in stream) {
        buffer += String.fromCharCodes(chunk);
        final lines = buffer.split('\n');
        buffer = lines.removeLast();

        for (final line in lines) {
          if (line.isEmpty || !line.startsWith('data: ')) continue;
          
          final data = line.substring(6).trim();
          if (data.isEmpty || data == '[DONE]') continue;

          try {
            final json = jsonDecode(data);
            yield* _handleStreamEvent(json);
          } catch (e) {
            continue;
          }
        }
      }
    } on DioException catch (e) {
      yield StreamErrorEvent('Groq API streaming failed: ${e.message}', e);
    } catch (e) {
      yield StreamErrorEvent('Stream error: $e', e);
    }
  }

  Stream<ApiStreamEvent> _handleStreamEvent(Map<String, dynamic> event) async* {
    final choices = event['choices'] as List?;
    if (choices == null || choices.isEmpty) return;

    final choice = choices.first as Map<String, dynamic>;
    final delta = choice['delta'] as Map<String, dynamic>?;
    if (delta == null) return;

    // Handle text content
    if (delta.containsKey('content') && delta['content'] != null) {
      yield TextChunkEvent(delta['content'] as String);
    }

    // Handle tool calls
    if (delta.containsKey('tool_calls')) {
      final toolCalls = delta['tool_calls'] as List;
      for (final toolCall in toolCalls) {
        final toolCallMap = toolCall as Map<String, dynamic>;
        final function = toolCallMap['function'] as Map<String, dynamic>?;
        
        if (function != null && function['name'] != null) {
          yield ToolCallEvent(
            toolCallId: toolCallMap['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
            toolName: function['name'] as String,
            arguments: jsonDecode(function['arguments'] as String? ?? '{}'),
          );
        }
      }
    }

    // Check for finish reason
    final finishReason = choice['finish_reason'] as String?;
    if (finishReason != null) {
      yield StreamEndEvent(stopReason: finishReason);
    }
  }

  List<Map<String, dynamic>> _convertMessages(List<Message> messages, String? systemPrompt) {
    final converted = <Map<String, dynamic>>[];
    
    // Add system prompt if provided
    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      converted.add({
        'role': 'system',
        'content': systemPrompt,
      });
    }

    for (final msg in messages) {
      converted.add({
        'role': msg.role == MessageRole.user ? 'user' : 'assistant',
        'content': msg.content,
      });
    }

    return converted;
  }

  List<Map<String, dynamic>> _convertTools(List<Tool> tools) {
    return tools.map((tool) {
      return {
        'type': 'function',
        'function': {
          'name': tool.name,
          'description': tool.description,
          'parameters': tool.parameters,
        },
      };
    }).toList();
  }

  @override
  void dispose() {
    _dio.close();
  }
}
