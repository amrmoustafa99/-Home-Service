abstract class ProviderState {}

class ProviderInitial extends ProviderState {}

class ProviderLoading extends ProviderState {}

class ProviderSuccess extends ProviderState {}

class ProviderError extends ProviderState {
  final String message;

  ProviderError(this.message);
}