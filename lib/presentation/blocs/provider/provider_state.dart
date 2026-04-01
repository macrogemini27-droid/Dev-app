part of 'provider_bloc.dart';

abstract class ProviderState extends Equatable {
  const ProviderState();

  @override
  List<Object?> get props => [];
}

class ProviderInitial extends ProviderState {}

class ProviderLoading extends ProviderState {}

class ProviderLoaded extends ProviderState {
  final List<ProviderConfig> providers;
  final ProviderConfig? selectedProvider;

  const ProviderLoaded({
    required this.providers,
    required this.selectedProvider,
  });

  ProviderLoaded copyWith({
    List<ProviderConfig>? providers,
    ProviderConfig? selectedProvider,
  }) {
    return ProviderLoaded(
      providers: providers ?? this.providers,
      selectedProvider: selectedProvider ?? this.selectedProvider,
    );
  }

  @override
  List<Object?> get props => [providers, selectedProvider];
}

class ProviderError extends ProviderState {
  final String message;

  const ProviderError({required this.message});

  @override
  List<Object?> get props => [message];
}
