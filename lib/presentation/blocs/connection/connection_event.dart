part of 'connection_bloc.dart';

abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object?> get props => [];
}

class ConnectToServerEvent extends ConnectionEvent {
  final SSHConfig config;

  const ConnectToServerEvent({required this.config});

  @override
  List<Object?> get props => [config];
}

class DisconnectFromServerEvent extends ConnectionEvent {
  const DisconnectFromServerEvent();
}

class ConnectionStatusChangedEvent extends ConnectionEvent {
  final SSHConnectionStatus status;

  const ConnectionStatusChangedEvent({required this.status});

  @override
  List<Object?> get props => [status];
}

class LoadSavedConfigsEvent extends ConnectionEvent {}

class DeleteConfigEvent extends ConnectionEvent {
  final String configId;

  const DeleteConfigEvent({required this.configId});

  @override
  List<Object?> get props => [configId];
}
