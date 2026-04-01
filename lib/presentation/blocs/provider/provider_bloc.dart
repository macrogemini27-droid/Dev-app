import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/provider_config.dart';
import '../../../domain/usecases/provider/add_provider.dart';
import '../../../domain/usecases/provider/get_providers.dart';

part 'provider_event.dart';
part 'provider_state.dart';

class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  final AddProvider addProvider;
  final GetProviders getProviders;

  ProviderBloc({
    required this.addProvider,
    required this.getProviders,
  }) : super(ProviderInitial()) {
    on<LoadProvidersEvent>(_onLoadProviders);
    on<AddProviderEvent>(_onAddProvider);
    on<SelectProviderEvent>(_onSelectProvider);
  }

  Future<void> _onLoadProviders(
    LoadProvidersEvent event,
    Emitter<ProviderState> emit,
  ) async {
    emit(ProviderLoading());

    final result = await getProviders();

    result.fold(
      (failure) => emit(ProviderError(message: failure.message)),
      (providers) {
        final selectedProvider = providers.firstWhere(
          (p) => p.isDefault,
          orElse: () => providers.isNotEmpty ? providers.first : throw Exception('No providers'),
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
    if (state is! ProviderLoaded) return;

    final currentState = state as ProviderLoaded;
    emit(ProviderLoading());

    final result = await addProvider(event.provider);

    result.fold(
      (failure) => emit(ProviderError(message: failure.message)),
      (_) {
        final updatedProviders = [...currentState.providers, event.provider];
        emit(ProviderLoaded(
          providers: updatedProviders,
          selectedProvider: currentState.selectedProvider,
        ));
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
}
