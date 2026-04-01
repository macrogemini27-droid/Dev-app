part of 'connection_bloc.dart';

abstract class ConnectionState extends Equatable {
  const ConnectionState();

  @override
  List<Object?> get props => [];
}

class ConnectionInitial extends ConnectionState {}

class ConnectionConnecting extends ConnectionState {
  final SSHConfig config;

  const ConnectionConnecting({required this.config});

  @override
  List<Object?> get props => [config];
}

class ConnectionConnected extends ConnectionState {
  final SSHConfig config;

  const ConnectionConnected({required this.config});

  @override
  List<Object?> get props => [config];
}

class ConnectionDisconnecting extends ConnectionState {}

class ConnectionDisconnected extends ConnectionState {}

class ConnectionReconnecting extends ConnectionState {}

class ConnectionError extends ConnectionState {
  final String message;
  final SSHConfig? config;

  const ConnectionError({required this.message, this.config});

  @override
  List<Object?> get props => [message, config];
}
