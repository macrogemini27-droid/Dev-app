import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/provider_config.dart';
import '../../../domain/usecases/provider/add_provider.dart';
import '../../../domain/usecases/provider/get_providers.dart';
import '../../../domain/usecases/provider/delete_provider.dart';
import '../../../domain/usecases/provider/update_provider.dart';
import '../../../domain/usecases/provider/set_default_provider.dart';
import '../../../core/services/app_logger.dart';

part 'provider_event.dart';
part 'provider_state.dart';

class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  final AddProvider addProvider;
  final GetProviders getProviders;
  final DeleteProvider deleteProvider;
  final UpdateProvider updateProvider;
  final SetDefaultProvider setDefaultProvider;
  final _logger = AppLogger();

  ProviderBloc({
    required this.addProvider,
    required this.getProviders,
    required this.deleteProvider,
    required this.updateProvider,
    required this.setDefaultProvider,
  }) : super(ProviderInitial()) {
    _logger.info('ProviderBloc initialized', tag: 'ProviderBloc');
    on<LoadProvidersEvent>(_onLoadProviders);
    on<AddProviderEvent>(_onAddProvider);
    on<SelectProviderEvent>(_onSelectProvider);
    on<SetDefaultProviderEvent>(_onSetDefaultProvider);
    on<DeleteProviderEvent>(_onDeleteProvider);
  }

  Future<void> _onLoadProviders(
    LoadProvidersEvent event,
    Emitter<ProviderState> emit,
  ) async {
    _logger.debug('Loading providers', tag: 'ProviderBloc');
    emit(ProviderLoading());

    final result = await getProviders();

    result.fold(
      (failure) {
        _logger.error('Failed to load providers: ${failure.toString()}', tag: 'ProviderBloc');
        emit(ProviderError(message: failure.toString()));
      },
      (providers) {
        _logger.info('Loaded ${providers.length} providers', tag: 'ProviderBloc');
        if (providers.isEmpty) {
          _logger.warning('No providers configured', tag: 'ProviderBloc');
          emit(ProviderLoaded(providers: [], selectedProvider: null));
          return;
        }

        final selectedProvider = providers.firstWhere(
          (p) => p.isDefault,
          orElse: () => providers.first,
        );
        _logger.debug('Selected provider: ${selectedProvider.name}', tag: 'ProviderBloc');

        emit(ProviderLoaded(
          providers: providers,
          selectedProvider: selectedProvider,
        ));
      },
    );
  }

  Future<void> _onAddProvider(
    AddProviderEvent event,
    Emitter<ProviderState> emit,
  ) async {
    _logger.info('Adding provider: ${event.provider.name} (${event.provider.type.name})', tag: 'ProviderBloc');
    final result = await addProvider(event.provider);

    result.fold(
      (failure) {
        _logger.error('Failed to add provider: ${failure.toString()}', tag: 'ProviderBloc');
        emit(ProviderError(message: failure.toString()));
      },
      (_) {
        _logger.info('Successfully added provider: ${event.provider.name}', tag: 'ProviderBloc');
        // Reload providers
        add(LoadProvidersEvent());
      },
    );
  }

  void _onSelectProvider(
    SelectProviderEvent event,
    Emitter<ProviderState> emit,
  ) {
    if (state is! ProviderLoaded) return;

    _logger.info('Selecting provider: ${event.provider.name}', tag: 'ProviderBloc');
    final currentState = state as ProviderLoaded;
    emit(currentState.copyWith(selectedProvider: event.provider));
  }

  Future<void> _onSetDefaultProvider(
    SetDefaultProviderEvent event,
    Emitter<ProviderState> emit,
  ) async {
    if (state is! ProviderLoaded) return;

    _logger.info('Setting default provider: ${event.providerId}', tag: 'ProviderBloc');
    final currentState = state as ProviderLoaded;
    
    // First, set the default provider
    final setDefaultResult = await setDefaultProvider(event.providerId);
    
    await setDefaultResult.fold(
      (failure) async {
        _logger.error('Failed to set default provider: ${failure.toString()}', tag: 'ProviderBloc');
        emit(ProviderError(message: failure.toString()));
      },
      (_) async {
        _logger.debug('Updating provider default flags', tag: 'ProviderBloc');
        // Update all providers to reflect the new default
        final updatedProviders = currentState.providers.map((p) {
          return p.copyWith(isDefault: p.id == event.providerId);
        }).toList();

        // Update each provider
        for (final provider in updatedProviders) {
          await updateProvider(provider);
        }

        _logger.info('Successfully set default provider', tag: 'ProviderBloc');
        // Reload providers
        add(LoadProvidersEvent());
      },
    );
  }

  Future<void> _onDeleteProvider(
    DeleteProviderEvent event,
    Emitter<ProviderState> emit,
  ) async {
    _logger.info('Deleting provider: ${event.providerId}', tag: 'ProviderBloc');
    final result = await deleteProvider(event.providerId);

    result.fold(
      (failure) {
        _logger.error('Failed to delete provider: ${failure.toString()}', tag: 'ProviderBloc');
        emit(ProviderError(message: failure.toString()));
      },
      (_) {
        _logger.info('Successfully deleted provider', tag: 'ProviderBloc');
        // Reload providers
        add(LoadProvidersEvent());
      },
    );
  }

  Future<void> _onSetDefaultProvider(
    SetDefaultProviderEvent event,
    Emitter<ProviderState> emit,
  ) async {
    if (state is! ProviderLoaded) return;

    final currentState = state as ProviderLoaded;
    
    // First, set the default provider
    final setDefaultResult = await setDefaultProvider(event.providerId);
    
    await setDefaultResult.fold(
      (failure) async {
        emit(ProviderError(message: failure.toString()));
      },
      (_) async {
        // Update all providers to reflect the new default
        final updatedProviders = currentState.providers.map((p) {
          return p.copyWith(isDefault: p.id == event.providerId);
        }).toList();

        // Update each provider
        for (final provider in updatedProviders) {
          await updateProvider(provider);
        }

        // Reload providers
        add(LoadProvidersEvent());
      },
    );
  }

  Future<void> _onDeleteProvider(
    DeleteProviderEvent event,
    Emitter<ProviderState> emit,
  ) async {
    if (state is! ProviderLoaded) return;

    // Delete the provider
    final result = await deleteProvider(event.providerId);

    result.fold(
      (failure) => emit(ProviderError(message: failure.toString())),
      (_) {
        // Reload providers after successful deletion
        add(LoadProvidersEvent());
      },
    );
  }
}
