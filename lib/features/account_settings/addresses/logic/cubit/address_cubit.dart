import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/address_model.dart';
import '../../data/models/addresses_copy.dart';
import '../../data/repositories/address_repository.dart';
import 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit({required AddressRepository repository})
      : _repository = repository,
        super(const AddressInitial());

  final AddressRepository _repository;

  StreamSubscription<List<AddressModel>>? _addressSubscription;

  List<AddressModel>? get _lastKnownAddresses {
    if (state is AddressLoaded) return (state as AddressLoaded).addresses;
    if (state is AddressActionInProgress) {
      return (state as AddressActionInProgress).addresses;
    }
    if (state is AddressError) return (state as AddressError).lastKnownAddresses;
    return null;
  }

  bool get _hasData {
    final lastKnown = _lastKnownAddresses;
    return lastKnown != null && lastKnown.isNotEmpty;
  }

  void listenToAddresses() {
    if (_addressSubscription != null) return;

    if (!_hasData) {
      emit(const AddressLoading());
    }

    _addressSubscription = _repository.watchAddresses().listen(
          (addresses) {
            if (addresses.isEmpty) {
              emit(const AddressEmpty());
            } else {
              emit(AddressLoaded(addresses));
            }
          },
          onError: (_, __) {
            emit(AddressError(
              message: AddressesCopy.loadingError,
              lastKnownAddresses: _lastKnownAddresses,
            ));
          },
        );
  }

  Future<void> addAddress(AddressModel address) async {
    emit(AddressActionInProgress(_lastKnownAddresses ?? const []));
    try {
      await _repository.addAddress(address);
    } catch (_) {
      emit(AddressError(
        message: AddressesCopy.addError,
        lastKnownAddresses: _lastKnownAddresses,
      ));
    }
  }

  Future<void> updateAddress(AddressModel address) async {
    emit(AddressActionInProgress(_lastKnownAddresses ?? const []));
    try {
      await _repository.updateAddress(address);
    } catch (_) {
      emit(AddressError(
        message: AddressesCopy.updateError,
        lastKnownAddresses: _lastKnownAddresses,
      ));
    }
  }

  Future<void> deleteAddress(String addressId) async {
    emit(AddressActionInProgress(_lastKnownAddresses ?? const []));
    try {
      await _repository.deleteAddress(addressId);
    } catch (_) {
      emit(AddressError(
        message: AddressesCopy.deleteError,
        lastKnownAddresses: _lastKnownAddresses,
      ));
    }
  }

  Future<void> setDefaultAddress(String addressId) async {
    emit(AddressActionInProgress(_lastKnownAddresses ?? const []));
    try {
      await _repository.setDefaultAddress(addressId);
    } catch (_) {
      emit(AddressError(
        message: AddressesCopy.setDefaultError,
        lastKnownAddresses: _lastKnownAddresses,
      ));
    }
  }

  @override
  Future<void> close() {
    _addressSubscription?.cancel();
    return super.close();
  }
}