abstract class Failure {
  final String message;
  final String? code;
  final dynamic details;

  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => message;
}

class SSHConnectionFailure extends Failure {
  const SSHConnectionFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class SSHAuthenticationFailure extends Failure {
  const SSHAuthenticationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class SSHCommandFailure extends Failure {
  const SSHCommandFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class APIFailure extends Failure {
  const APIFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class ToolExecutionFailure extends Failure {
  const ToolExecutionFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.details,
  });
}
