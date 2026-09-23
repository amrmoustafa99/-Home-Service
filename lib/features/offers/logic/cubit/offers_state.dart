import 'package:equatable/equatable.dart';

import '../../data/models/offer_model.dart';

sealed class OffersState extends Equatable {
  const OffersState();

  @override
  List<Object?> get props => [];
}

class OffersInitial extends OffersState {
  const OffersInitial();
}

class OffersLoading extends OffersState {
  const OffersLoading();
}

class OffersLoaded extends OffersState {
  final List<Offer> offers;

  const OffersLoaded(this.offers);

  @override
  List<Object?> get props => [offers];
}

class OffersEmpty extends OffersState {
  const OffersEmpty();
}

class OffersError extends OffersState {
  final String message;

  const OffersError(this.message);

  @override
  List<Object?> get props => [message];
}
