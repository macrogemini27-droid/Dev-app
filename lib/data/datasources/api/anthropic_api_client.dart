import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:claude_code_mobile/core/constants/app_constants.dart';

class AnthropicApiClient {
  late final Dio _dio;

  AnthropicApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.anthropicApiUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 120),
        headers: {
          'Content-Type': 'application/json',
          'anthropic-version': '2023-06-01',
        },
      ),
    );
  }

  Future<Map<String, dynamic>> createMessage({
    required String apiKey,
    required String model,
    required List<Map<String, dynamic>> messages,
    String? systemPrompt,
    List<Map<String, dynamic>>? tools,
    int? maxTokens,
  }) async {
    try {
      final response = await _dio.post(
        '/messages',
        options: Options(
          headers: {
            'x-api-key': apiKey,
          },
        ),
        data: {
          'model': model,
          'messages': messages,
          if (systemPrompt != null) 'system': systemPrompt,
          if (tools != null) 'tools': tools,
          'max_tokens': maxTokens ?? AppConstants.maxTokens,
        },
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('API request failed: ${e.message}');
    }
  }

  Stream<Map<String, dynamic>> streamMessage({
    required String apiKey,
    required String model,
    required List<Map<String, dynamic>> messages,
    String? systemPrompt,
    List<Map<String, dynamic>>? tools,
    int? maxTokens,
  }) async* {
    try {
      final response = await _dio.post(
        '/messages',
        options: Options(
          headers: {
            'x-api-key': apiKey,
          },
          responseType: ResponseType.stream,
        ),
        data: {
          'model': model,
          'messages': messages,
          if (systemPrompt != null) 'system': systemPrompt,
          if (tools != null) 'tools': tools,
          'max_tokens': maxTokens ?? AppConstants.maxTokens,
          'stream': true,
        },
      );

      final stream = response.data.stream;
      await for (final chunk in stream) {
        final lines = String.fromCharCodes(chunk).split('\n');
        for (final line in lines) {
          if (line.startsWith('data: ')) {
            final jsonStr = line.substring(6);
            if (jsonStr.trim().isNotEmpty && jsonStr != '[DONE]') {
              yield Map<String, dynamic>.from(
                _parseJson(jsonStr),
              );
            }
          }
        }
      }
    } on DioException catch (e) {
      throw Exception('API streaming failed: ${e.message}');
    }
  }

  dynamic _parseJson(String jsonStr) {
    try {
      return jsonDecode(jsonStr);
    } catch (e) {
      return {};
    }
  }
}
