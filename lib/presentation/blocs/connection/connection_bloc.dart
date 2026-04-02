import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/ssh_config.dart';
import '../../../domain/usecases/ssh/connect_ssh.dart';
import '../../../domain/usecases/ssh/disconnect_ssh.dart';
import '../../../domain/usecases/ssh/save_ssh_config.dart';
import '../../../domain/usecases/ssh/get_saved_configs.dart';
import '../../../domain/usecases/ssh/delete_ssh_config.dart';
import '../../../core/services/app_logger.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  final ConnectSSH connectSSH;
  final DisconnectSSH disconnectSSH;
  final SaveSSHConfig saveSSHConfig;
  final GetSavedConfigs getSavedConfigs;
  final DeleteSSHConfig deleteSSHConfig;
  final _logger = AppLogger();

  ConnectionBloc({
    required this.connectSSH,
    required this.disconnectSSH,
    required this.saveSSHConfig,
    required this.getSavedConfigs,
    required this.deleteSSHConfig,
  }) : super(ConnectionInitial()) {
    _logger.info('ConnectionBloc initialized', tag: 'ConnectionBloc');
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
    _logger.info('Connecting to server: ${event.config.host}:${event.config.port}', tag: 'ConnectionBloc');
    emit(ConnectionConnecting(config: event.config));

    // Save config first
    _logger.debug('Saving SSH config: ${event.config.name}', tag: 'ConnectionBloc');
    await saveSSHConfig(event.config);

    final result = await connectSSH(event.config);

    result.fold(
      (failure) {
        _logger.error('Connection failed: ${failure.toString()}', tag: 'ConnectionBloc');
        emit(ConnectionError(
          message: failure.toString(),
          config: event.config,
        ));
      },
      (_) {
        _logger.info('Successfully connected to ${event.config.host}', tag: 'ConnectionBloc');
        emit(ConnectionConnected(config: event.config));
      },
    );
  }

  Future<void> _onDisconnectFromServer(
    DisconnectFromServerEvent event,
    Emitter<ConnectionState> emit,
  ) async {
    _logger.info('Disconnecting from server', tag: 'ConnectionBloc');
    emit(ConnectionDisconnecting());

    final result = await disconnectSSH();

    await result.fold(
      (failure) async {
        _logger.error('Disconnect failed: ${failure.toString()}', tag: 'ConnectionBloc');
        emit(ConnectionError(message: failure.toString()));
      },
      (_) async {
        _logger.info('Successfully disconnected', tag: 'ConnectionBloc');
        // After disconnect, reload saved configs to show them
        final configsResult = await getSavedConfigs();
        configsResult.fold(
          (failure) {
            _logger.warning('Failed to load configs after disconnect', tag: 'ConnectionBloc');
            emit(ConnectionDisconnected());
          },
          (configs) {
            _logger.debug('Loaded ${configs.length} saved configs', tag: 'ConnectionBloc');
            emit(ConnectionConfigsLoaded(configs: configs));
          },
        );
      },
    );
  }

  void _onConnectionStatusChanged(
    ConnectionStatusChangedEvent event,
    Emitter<ConnectionState> emit,
  ) {
    _logger.debug('Connection status changed: ${event.status}', tag: 'ConnectionBloc');
    switch (event.status) {
      case SSHConnectionStatus.connected:
        if (state is ConnectionConnecting) {
          final currentState = state as ConnectionConnecting;
          _logger.info('Connection status updated to connected', tag: 'ConnectionBloc');
          emit(ConnectionConnected(config: currentState.config));
        }
        break;
      case SSHConnectionStatus.disconnected:
        _logger.info('Connection status updated to disconnected', tag: 'ConnectionBloc');
        emit(ConnectionDisconnected());
        break;
      case SSHConnectionStatus.error:
        _logger.error('Connection status updated to error', tag: 'ConnectionBloc');
        emit(const ConnectionError(message: 'Connection error'));
        break;
      case SSHConnectionStatus.reconnecting:
        _logger.warning('Connection status updated to reconnecting', tag: 'ConnectionBloc');
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
    _logger.debug('Loading saved SSH configs', tag: 'ConnectionBloc');
    emit(ConnectionLoadingConfigs());

    final result = await getSavedConfigs();

    result.fold(
      (failure) {
        _logger.error('Failed to load saved configs: ${failure.toString()}', tag: 'ConnectionBloc');
        emit(ConnectionError(message: failure.toString()));
      },
      (configs) {
        _logger.info('Loaded ${configs.length} saved SSH configs', tag: 'ConnectionBloc');
        emit(ConnectionConfigsLoaded(configs: configs));
      },
    );
  }

  Future<void> _onDeleteConfig(
    DeleteConfigEvent event,
    Emitter<ConnectionState> emit,
  ) async {
    _logger.info('Deleting SSH config: ${event.configId}', tag: 'ConnectionBloc');
    
    final result = await deleteSSHConfig(event.configId);

    await result.fold(
      (failure) async {
        _logger.error('Failed to delete config: ${failure.toString()}', tag: 'ConnectionBloc');
        emit(ConnectionError(message: failure.toString()));
      },
      (_) async {
        _logger.info('Successfully deleted config', tag: 'ConnectionBloc');
        // Reload configs after deletion
        final configsResult = await getSavedConfigs();
        configsResult.fold(
          (failure) {
            _logger.error('Failed to reload configs after deletion', tag: 'ConnectionBloc');
            emit(ConnectionError(message: failure.toString()));
          },
          (configs) {
            _logger.debug('Reloaded ${configs.length} configs after deletion', tag: 'ConnectionBloc');
            emit(ConnectionConfigsLoaded(configs: configs));
          },
        );
      },
    );
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
