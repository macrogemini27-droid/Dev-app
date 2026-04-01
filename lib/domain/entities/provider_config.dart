import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider_config.freezed.dart';
part 'provider_config.g.dart';

@freezed
class ProviderConfig with _$ProviderConfig {
  const factory ProviderConfig({
    required String id,
    required String name,
    required ProviderType type,
    required String apiKey,
    String? baseUrl,
    String? customModelName, // Allow users to specify exact model name
    @Default(false) bool isDefault,
    DateTime? createdAt,
  }) = _ProviderConfig;

  factory ProviderConfig.fromJson(Map<String, dynamic> json) =>
      _$ProviderConfigFromJson(json);
}

enum ProviderType {
  anthropic,
  gemini,
  groq,
  bedrock,
  vertex,
  custom,
}

extension ProviderTypeExtension on ProviderType {
  String get displayName {
    switch (this) {
      case ProviderType.anthropic:
        return 'Anthropic';
      case ProviderType.gemini:
        return 'Google Gemini';
      case ProviderType.groq:
        return 'Groq';
      case ProviderType.bedrock:
        return 'AWS Bedrock';
      case ProviderType.vertex:
        return 'Google Vertex AI';
      case ProviderType.custom:
        return 'Custom';
    }
  }

  String get defaultBaseUrl {
    switch (this) {
      case ProviderType.anthropic:
        return 'https://api.anthropic.com/v1';
      case ProviderType.gemini:
        return 'https://generativelanguage.googleapis.com/v1beta';
      case ProviderType.groq:
        return 'https://api.groq.com/openai/v1';
      case ProviderType.bedrock:
        return 'https://bedrock-runtime.us-east-1.amazonaws.com';
      case ProviderType.vertex:
        return 'https://us-central1-aiplatform.googleapis.com';
      case ProviderType.custom:
        return '';
    }
  }

  String get defaultModel {
    switch (this) {
      case ProviderType.anthropic:
        return 'claude-3-5-sonnet-20241022';
      case ProviderType.gemini:
        return 'gemini-2.0-flash-exp';
      case ProviderType.groq:
        return 'llama-3.3-70b-versatile';
      case ProviderType.bedrock:
        return 'anthropic.claude-3-5-sonnet-20241022-v2:0';
      case ProviderType.vertex:
        return 'claude-3-5-sonnet-v2@20241022';
      case ProviderType.custom:
        return '';
    }
  }

  bool get supportsStreaming {
    return true; // All providers support streaming
  }

  bool get supportsTools {
    switch (this) {
      case ProviderType.anthropic:
      case ProviderType.gemini:
      case ProviderType.groq:
      case ProviderType.bedrock:
      case ProviderType.vertex:
        return true;
      case ProviderType.custom:
        return true; // Assume custom providers support tools
    }
  }
}
