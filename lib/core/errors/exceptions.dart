class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'AppException: $message';
}

class SSHException extends AppException {
  SSHException({
    required super.message,
    super.code,
    super.details,
  });
}

class APIException extends AppException {
  APIException({
    required super.message,
    super.code,
    super.details,
  });
}

class StorageException extends AppException {
  StorageException({
    required super.message,
    super.code,
    super.details,
  });
}

class ValidationException extends AppException {
  ValidationException({
    required super.message,
    super.code,
    super.details,
  });
}
