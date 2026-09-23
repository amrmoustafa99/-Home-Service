import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/offers_copy.dart';
import '../../data/repositories/offers_repository.dart';
import 'offers_state.dart';

class OffersCubit extends Cubit<OffersState> {
  final OffersRepository _repository;

  OffersCubit(this._repository) : super(const OffersInitial());

  Future<void> fetchOffers() async {
    emit(const OffersLoading());
    try {
      final offers = await _repository.getOffers();
      if (offers.isEmpty) {
        emit(const OffersEmpty());
      } else {
        emit(OffersLoaded(offers));
      }
    } on OffersFetchException catch (e) {
      emit(OffersError(e.message));
    } catch (_) {
      emit(const OffersError(OffersCopy.defaultError));
    }
  }

  Future<void> retryFetch() async {
    await fetchOffers();
  }
}
