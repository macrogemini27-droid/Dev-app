part of 'provider_bloc.dart';

abstract class ProviderEvent extends Equatable {
  const ProviderEvent();

  @override
  List<Object?> get props => [];
}

class LoadProvidersEvent extends ProviderEvent {
  const LoadProvidersEvent();
}

class AddProviderEvent extends ProviderEvent {
  final ProviderConfig provider;

  const AddProviderEvent({required this.provider});

  @override
  List<Object?> get props => [provider];
}

class SelectProviderEvent extends ProviderEvent {
  final ProviderConfig provider;

  const SelectProviderEvent({required this.provider});

  @override
  List<Object?> get props => [provider];
}
