class AppConstants {
  // App Info
  static const String appName = 'Claude Code Mobile';
  static const String appVersion = '1.0.0';

  // SSH
  static const int defaultSSHPort = 22;
  static const int sshConnectionTimeout = 30; // seconds
  static const int sshCommandTimeout = 120; // seconds
  static const int maxRetries = 3;

  // Tool Execution
  static const int maxConcurrentReadTools = 10;
  static const int toolExecutionTimeout = 300; // seconds
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB

  // Cache
  static const int cacheMaxSize = 100 * 1024 * 1024; // 100MB
  static const Duration cacheTTL = Duration(minutes: 30);

  // Session
  static const int maxMessagesPerSession = 10000;
  static const int messageLoadBatchSize = 50;

  // API
  static const String anthropicApiUrl = 'https://api.anthropic.com/v1';
  static const String defaultModel = 'claude-3-5-sonnet-20241022';
  static const int maxTokens = 4096;

  // UI
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration debounceDelay = Duration(milliseconds: 500);
}
