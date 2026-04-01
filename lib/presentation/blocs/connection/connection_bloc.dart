import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/ssh_config.dart';
import '../../../domain/usecases/ssh/connect_ssh.dart';
import '../../../domain/usecases/ssh/disconnect_ssh.dart';
import '../../../domain/usecases/ssh/save_ssh_config.dart';
import '../../../domain/usecases/ssh/get_saved_configs.dart';
import '../../../domain/usecases/ssh/delete_ssh_config.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  final ConnectSSH connectSSH;
  final DisconnectSSH disconnectSSH;
  final SaveSSHConfig saveSSHConfig;
  final GetSavedConfigs getSavedConfigs;
  final DeleteSSHConfig deleteSSHConfig;

  ConnectionBloc({
    required this.connectSSH,
    required this.disconnectSSH,
    required this.saveSSHConfig,
    required this.getSavedConfigs,
    required this.deleteSSHConfig,
  }) : super(ConnectionInitial()) {
    on<ConnectToServerEvent>(_onConnectToServer);
    on<DisconnectFromServerEvent>(_onDisconnectFromServer);
    on<ConnectionStatusChangedEvent>(_onConnectionStatusChanged);
    on<LoadSavedConfigsEvent>(_onLoadSavedConfigs);
    on<DeleteConfigEvent>(_onDeleteConfig);
  }

  Future<void> _onConnectToServer(
    ConnectToServerEvent event,
    Emitter<ConnectionState> emit,
  ) async {
    emit(ConnectionConnecting(config: event.config));

    // Save config first
    await saveSSHConfig(event.config);

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

  Future<void> _onLoadSavedConfigs(
    LoadSavedConfigsEvent event,
    Emitter<ConnectionState> emit,
  ) async {
    emit(ConnectionLoadingConfigs());

    final result = await getSavedConfigs();

    result.fold(
      (failure) => emit(ConnectionError(message: failure.toString())),
      (configs) => emit(ConnectionConfigsLoaded(configs: configs)),
    );
  }

  Future<void> _onDeleteConfig(
    DeleteConfigEvent event,
    Emitter<ConnectionState> emit,
  ) async {
    final result = await deleteSSHConfig(event.configId);

    result.fold(
      (failure) => emit(ConnectionError(message: failure.toString())),
      (_) {
        // Reload configs after deletion
        add(LoadSavedConfigsEvent());
      },
    );
  }
}
