import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/ssh_config.dart';
import '../../../domain/usecases/ssh/connect_ssh.dart';
import '../../../domain/usecases/ssh/disconnect_ssh.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  final ConnectSSH connectSSH;
  final DisconnectSSH disconnectSSH;

  ConnectionBloc({
    required this.connectSSH,
    required this.disconnectSSH,
  }) : super(ConnectionInitial()) {
    on<ConnectToServerEvent>(_onConnectToServer);
    on<DisconnectFromServerEvent>(_onDisconnectFromServer);
    on<ConnectionStatusChangedEvent>(_onConnectionStatusChanged);
  }

  Future<void> _onConnectToServer(
    ConnectToServerEvent event,
    Emitter<ConnectionState> emit,
  ) async {
    emit(ConnectionConnecting(config: event.config));

    final result = await connectSSH(event.config);

    result.fold(
      (failure) => emit(ConnectionError(
        message: failure.toString(),
        config: event.config,
      )),
      (_) => emit(ConnectionConnected(config: event.config)),
    );
  }

  Future<void> _onDisconnectFromServer(
    DisconnectFromServerEvent event,
    Emitter<ConnectionState> emit,
  ) async {
    emit(ConnectionDisconnecting());

    final result = await disconnectSSH();

    result.fold(
      (failure) => emit(ConnectionError(message: failure.toString())),
      (_) => emit(ConnectionDisconnected()),
    );
  }

  void _onConnectionStatusChanged(
    ConnectionStatusChangedEvent event,
    Emitter<ConnectionState> emit,
  ) {
    switch (event.status) {
      case SSHConnectionStatus.connected:
        if (state is ConnectionConnecting) {
          final currentState = state as ConnectionConnecting;
          emit(ConnectionConnected(config: currentState.config));
        }
        break;
      case SSHConnectionStatus.disconnected:
        emit(ConnectionDisconnected());
        break;
      case SSHConnectionStatus.error:
        emit(const ConnectionError(message: 'Connection error'));
        break;
      case SSHConnectionStatus.reconnecting:
        emit(ConnectionReconnecting());
        break;
      default:
        break;
    }
  }
}
