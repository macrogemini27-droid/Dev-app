import '../../../domain/entities/provider_config.dart';
import 'anthropic_api_client.dart';
import 'gemini_api_client.dart';
import 'groq_api_client.dart';
import 'base_api_client.dart';

/// Factory to create appropriate API client based on provider type
class ApiClientFactory {
  static BaseApiClient createClient(ProviderConfig config) {
    switch (config.type) {
      case ProviderType.anthropic:
      case ProviderType.bedrock:
      case ProviderType.vertex:
        return AnthropicApiClient(config: config);
      
      case ProviderType.gemini:
        return GeminiApiClient(config: config);
      
      case ProviderType.groq:
        return GroqApiClient(config: config);
      
      case ProviderType.custom:
        // For custom providers, try to detect the format based on baseUrl
        // Default to OpenAI-compatible format (like Groq)
        return GroqApiClient(config: config);
    }
  }
}
