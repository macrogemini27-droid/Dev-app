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

class SetDefaultProviderEvent extends ProviderEvent {
  final String providerId;

  const SetDefaultProviderEvent({required this.providerId});

  @override
  List<Object?> get props => [providerId];
}

class DeleteProviderEvent extends ProviderEvent {
  final String providerId;

  const DeleteProviderEvent({required this.providerId});

  @override
  List<Object?> get props => [providerId];
}
