import 'package:equatable/equatable.dart';

import '../../data/models/address_model.dart';

sealed class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => const [];
}

class AddressInitial extends AddressState {
  const AddressInitial();
}

class AddressLoading extends AddressState {
  const AddressLoading();
}

class AddressEmpty extends AddressState {
  const AddressEmpty();
}

class AddressLoaded extends AddressState {
  const AddressLoaded(this.addresses);

  final List<AddressModel> addresses;

  @override
  List<Object?> get props => [addresses];
}

class AddressActionInProgress extends AddressState {
  const AddressActionInProgress(this.addresses);

  final List<AddressModel> addresses;

  @override
  List<Object?> get props => [addresses];
}

class AddressError extends AddressState {
  const AddressError({
    required this.message,
    required this.lastKnownAddresses,
  });

  final String message;
  final List<AddressModel>? lastKnownAddresses;

  @override
  List<Object?> get props => [message, lastKnownAddresses];
}