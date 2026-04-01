import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/provider_config.dart';
import '../../../domain/usecases/provider/add_provider.dart';
import '../../../domain/usecases/provider/get_providers.dart';
import '../../../domain/usecases/provider/delete_provider.dart';
import '../../../domain/usecases/provider/update_provider.dart';
import '../../../domain/usecases/provider/set_default_provider.dart';

part 'provider_event.dart';
part 'provider_state.dart';

class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  final AddProvider addProvider;
  final GetProviders getProviders;
  final DeleteProvider deleteProvider;
  final UpdateProvider updateProvider;
  final SetDefaultProvider setDefaultProvider;

  ProviderBloc({
    required this.addProvider,
    required this.getProviders,
    required this.deleteProvider,
    required this.updateProvider,
    required this.setDefaultProvider,
  }) : super(ProviderInitial()) {
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
    emit(ProviderLoading());

    final result = await getProviders();

    result.fold(
      (failure) => emit(ProviderError(message: failure.toString())),
      (providers) {
        if (providers.isEmpty) {
          emit(ProviderLoaded(providers: [], selectedProvider: null));
          return;
        }

        final selectedProvider = providers.firstWhere(
          (p) => p.isDefault,
          orElse: () => providers.first,
        );

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
    final result = await addProvider(event.provider);

    result.fold(
      (failure) => emit(ProviderError(message: failure.toString())),
      (_) {
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

    final currentState = state as ProviderLoaded;
    emit(currentState.copyWith(selectedProvider: event.provider));
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
