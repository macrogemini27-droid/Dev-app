import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../domain/entities/provider_config.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/entities/tool.dart';
import 'base_api_client.dart';

class AnthropicApiClient extends BaseApiClient {
  late final Dio _dio;

  AnthropicApiClient({
    required super.config,
  }) : super() {
    _dio = Dio(
      BaseOptions(
        baseUrl: getBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 120),
        headers: {
          'Content-Type': 'application/json',
          'anthropic-version': '2023-06-01',
          'x-api-key': config.apiKey,
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
        '/messages',
        options: Options(
          responseType: ResponseType.stream,
        ),
        data: {
          'model': getModelName(),
          'messages': _convertMessages(messages),
          if (systemPrompt != null) 'system': systemPrompt,
          if (tools.isNotEmpty) 'tools': _convertTools(tools),
          'max_tokens': maxTokens ?? 4096,
          'temperature': temperature ?? 1.0,
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
      yield StreamErrorEvent('API streaming failed: ${e.message}', e);
    } catch (e) {
      yield StreamErrorEvent('Stream error: $e', e);
    }
  }

  Stream<ApiStreamEvent> _handleStreamEvent(Map<String, dynamic> event) async* {
    final type = event['type'] as String?;

    switch (type) {
      case 'content_block_delta':
        final delta = event['delta'];
        if (delta['type'] == 'text_delta') {
          yield TextChunkEvent(delta['text'] as String);
        }
        break;

      case 'message_delta':
        final delta = event['delta'];
        if (delta['stop_reason'] != null) {
          yield StreamEndEvent(
            stopReason: delta['stop_reason'] as String?,
            usage: event['usage'] as Map<String, dynamic>?,
          );
        }
        break;

      case 'message_stop':
        yield StreamEndEvent();
        break;

      case 'error':
        yield StreamErrorEvent(
          event['error']?['message'] ?? 'Unknown error',
          event['error'],
        );
        break;
    }
  }

  List<Map<String, dynamic>> _convertMessages(List<Message> messages) {
    return messages.map((msg) {
      return {
        'role': msg.role == MessageRole.user ? 'user' : 'assistant',
        'content': msg.content,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _convertTools(List<Tool> tools) {
    return tools.map((tool) {
      return {
        'name': tool.name,
        'description': tool.description,
        'input_schema': tool.parameters,
      };
    }).toList();
  }

  @override
  void dispose() {
    _dio.close();
  }
}
