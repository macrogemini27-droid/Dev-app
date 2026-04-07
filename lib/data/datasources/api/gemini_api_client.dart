import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../domain/entities/provider_config.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/entities/tool.dart';
import 'base_api_client.dart';

class GeminiApiClient extends BaseApiClient {
  late final Dio _dio;

  GeminiApiClient({
    required super.config,
  }) : super() {
    _dio = Dio(
      BaseOptions(
        baseUrl: getBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 120),
        headers: {
          'Content-Type': 'application/json',
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
      final model = getModelName();
      final url = '/models/$model:streamGenerateContent?key=${config.apiKey}';
      
      final response = await _dio.post(
        url,
        options: Options(
          responseType: ResponseType.stream,
        ),
        data: {
          'contents': _convertMessages(messages, systemPrompt),
          if (systemPrompt != null && systemPrompt.isNotEmpty)
            'systemInstruction': {
              'parts': [{'text': systemPrompt}],
            },
          if (tools.isNotEmpty) 'tools': [{'functionDeclarations': _convertTools(tools)}],
          'generationConfig': {
            if (maxTokens != null) 'maxOutputTokens': maxTokens,
            if (temperature != null) 'temperature': temperature,
          },
        },
      );

      final stream = response.data.stream;
      String buffer = '';
      
      await for (final chunk in stream) {
        buffer += String.fromCharCodes(chunk);
        final lines = buffer.split('\n');
        buffer = lines.removeLast();

        for (final line in lines) {
          if (line.trim().isEmpty) continue;

          try {
            final json = jsonDecode(line);
            yield* _handleStreamEvent(json);
          } catch (e) {
            continue;
          }
        }
      }
    } on DioException catch (e) {
      yield StreamErrorEvent('Gemini API streaming failed: ${e.message}', e);
    } catch (e) {
      yield StreamErrorEvent('Stream error: $e', e);
    }
  }

  Stream<ApiStreamEvent> _handleStreamEvent(Map<String, dynamic> event) async* {
    final candidates = event['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) return;

    final candidate = candidates.first as Map<String, dynamic>;
    final content = candidate['content'] as Map<String, dynamic>?;
    if (content == null) return;

    final parts = content['parts'] as List?;
    if (parts == null || parts.isEmpty) return;

    for (final part in parts) {
      final partMap = part as Map<String, dynamic>;
      
      // Handle text response
      if (partMap.containsKey('text')) {
        yield TextChunkEvent(partMap['text'] as String);
      }
      
      // Handle function call (tool use)
      if (partMap.containsKey('functionCall')) {
        final functionCall = partMap['functionCall'] as Map<String, dynamic>;
        yield ToolCallEvent(
          toolCallId: DateTime.now().millisecondsSinceEpoch.toString(),
          toolName: functionCall['name'] as String,
          arguments: functionCall['args'] as Map<String, dynamic>,
        );
      }
    }

    // Check for finish reason
    final finishReason = candidate['finishReason'] as String?;
    if (finishReason != null) {
      yield StreamEndEvent(stopReason: finishReason);
    }
  }

  List<Map<String, dynamic>> _convertMessages(List<Message> messages, String? systemPrompt) {
    final contents = <Map<String, dynamic>>[];

    // System prompt is passed separately via systemInstruction in the request body,
    // so we do not inject it as a user message here.

    for (final msg in messages) {
      contents.add({
        'role': msg.role == MessageRole.user ? 'user' : 'model',
        'parts': [{'text': msg.content}],
      });
    }

    return contents;
  }

  List<Map<String, dynamic>> _convertTools(List<Tool> tools) {
    return tools.map((tool) {
      return {
        'name': tool.name,
        'description': tool.description,
        'parameters': tool.parameters,
      };
    }).toList();
  }

  @override
  void dispose() {
    _dio.close();
  }
}
