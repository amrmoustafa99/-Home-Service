import 'package:flutter_test/flutter_test.dart';
import 'package:home_service/features/offers/data/models/offer_model.dart';
import 'package:home_service/features/offers/data/repositories/offers_repository.dart';
import 'package:home_service/features/offers/logic/cubit/offers_cubit.dart';
import 'package:home_service/features/offers/logic/cubit/offers_state.dart';

class MockOffersRepository implements OffersRepository {
  final List<Offer> _offersToReturn;
  final Exception? _exceptionToThrow;

  MockOffersRepository({List<Offer>? offers, Exception? exception})
    : _offersToReturn = offers ?? [],
      _exceptionToThrow = exception;

  @override
  Future<List<Offer>> getOffers() async {
    if (_exceptionToThrow != null) {
      throw _exceptionToThrow;
    }
    return _offersToReturn;
  }
}

void main() {
  group('Offer Model Tests', () {
    test('isExpired returns true when isActive is false', () {
      final offer = Offer(
        id: '1',
        name: 'Test',
        description: 'Test Desc',
        code: 'CODE10',
        icon: 'star',
        usageNote: 'Note',
        isActive: false,
        expiryDate: DateTime.now().add(const Duration(days: 5)),
      );

      expect(offer.isExpired, isTrue);
    });

    test('isExpired returns true when expiryDate is in the past', () {
      final offer = Offer(
        id: '1',
        name: 'Test',
        description: 'Test Desc',
        code: 'CODE10',
        icon: 'star',
        usageNote: 'Note',
        isActive: true,
        expiryDate: DateTime.now().subtract(const Duration(days: 1)),
      );

      expect(offer.isExpired, isTrue);
    });

    test(
      'isExpired returns false when isActive is true and expiryDate is in future',
      () {
        final offer = Offer(
          id: '1',
          name: 'Test',
          description: 'Test Desc',
          code: 'CODE10',
          icon: 'star',
          usageNote: 'Note',
          isActive: true,
          expiryDate: DateTime.now().add(const Duration(days: 5)),
        );

        expect(offer.isExpired, isFalse);
      },
    );

    test(
      'hasProgress returns true when progressCurrent and progressTarget are present',
      () {
        final offer = Offer(
          id: '1',
          name: 'Test',
          description: 'Test Desc',
          code: 'CODE10',
          icon: 'star',
          usageNote: 'Note',
          isActive: true,
          expiryDate: DateTime.now().add(const Duration(days: 5)),
          progressCurrent: 2,
          progressTarget: 5,
        );

        expect(offer.hasProgress, isTrue);
      },
    );
  });

  group('OffersCubit Tests', () {
    test(
      'emits [OffersLoading, OffersLoaded] when fetchOffers succeeds with items',
      () async {
        final mockOffers = [
          Offer(
            id: '1',
            name: 'Summer Offer',
            description: 'Desc',
            code: 'SUMMER20',
            icon: 'ac_unit',
            usageNote: 'Seasonal',
            isActive: true,
            expiryDate: DateTime.now().add(const Duration(days: 10)),
          ),
        ];

        final cubit = OffersCubit(MockOffersRepository(offers: mockOffers));

        final expectedStates = [
          const OffersLoading(),
          OffersLoaded(mockOffers),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.fetchOffers();
      },
    );

    test(
      'emits [OffersLoading, OffersEmpty] when fetchOffers returns empty list',
      () async {
        final cubit = OffersCubit(MockOffersRepository(offers: []));

        final expectedStates = [const OffersLoading(), const OffersEmpty()];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.fetchOffers();
      },
    );

    test(
      'emits [OffersLoading, OffersError] when fetchOffers throws exception',
      () async {
        final cubit = OffersCubit(
          MockOffersRepository(
            exception: OffersFetchException('Failed connection'),
          ),
        );

        final expectedStates = [
          const OffersLoading(),
          const OffersError('Failed connection'),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.fetchOffers();
      },
    );
  });
}
