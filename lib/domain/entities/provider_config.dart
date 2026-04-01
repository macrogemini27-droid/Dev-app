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
    String? defaultModel,
    @Default(false) bool isDefault,
    DateTime? createdAt,
  }) = _ProviderConfig;

  factory ProviderConfig.fromJson(Map<String, dynamic> json) =>
      _$ProviderConfigFromJson(json);
}

enum ProviderType {
  anthropic,
  bedrock,
  vertex,
  custom,
}

extension ProviderTypeExtension on ProviderType {
  String get displayName {
    switch (this) {
      case ProviderType.anthropic:
        return 'Anthropic';
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
      case ProviderType.bedrock:
        return 'https://bedrock-runtime.us-east-1.amazonaws.com';
      case ProviderType.vertex:
        return 'https://us-central1-aiplatform.googleapis.com';
      case ProviderType.custom:
        return '';
    }
  }
}
