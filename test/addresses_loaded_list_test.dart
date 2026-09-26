import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_service/features/account_settings/addresses/data/models/address_model.dart';
import 'package:home_service/features/account_settings/addresses/data/repositories/address_repository.dart';
import 'package:home_service/features/account_settings/addresses/logic/cubit/address_cubit.dart';
import 'package:home_service/features/account_settings/addresses/logic/cubit/address_state.dart';
import 'package:home_service/features/account_settings/addresses/presentation/widgets/address_card.dart';
import 'package:home_service/features/account_settings/addresses/presentation/widgets/saved_addresses_list.dart';

void main() {
  const expectedDetails =
      'القاهرة، مدينة نصر، شارع عباس العقاد، عمارة 25، الدور 3';

  testWidgets('loaded list shows the heading, cards, and only one default pill',
      (tester) async {
    final addresses = [
      _address(title: 'المنزل', isDefault: true),
      _address(title: 'بيت العائلة'),
      _address(title: 'منزل والدتي'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SavedAddressesList(addresses: addresses)),
      ),
    );

    expect(find.text('عناوينك المحفوظة'), findsOneWidget);
    expect(find.text('المنزل'), findsOneWidget);
    expect(find.text('بيت العائلة'), findsOneWidget);
    expect(find.text('منزل والدتي'), findsOneWidget);
    expect(find.byType(AddressCard), findsNWidgets(3));
    expect(find.text('العنوان الأساسي'), findsOneWidget);

    expect(find.text(expectedDetails), findsNWidgets(3));
    expect(find.byIcon(Icons.more_vert), findsNWidgets(3));
  });

  testWidgets('keeps the list visible with a thin progress bar while '
      'refreshing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SavedAddressesList(
            addresses: [_address(title: 'المنزل', isDefault: true)],
            isRefreshing: true,
          ),
        ),
      ),
    );

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('المنزل'), findsOneWidget);
  });

  testWidgets('shows a dismissible error banner above the existing list',
      (tester) async {
    String? dismissedKey;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => SavedAddressesList(
              addresses: [_address(title: 'المنزل', isDefault: true)],
              errorMessage: 'حدث خطأ أثناء تحميل العناوين',
              showErrorBanner: dismissedKey == null,
              onDismissError: () =>
                  setState(() => dismissedKey = 'dismissed'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('حدث خطأ أثناء تحميل العناوين'), findsOneWidget);
    expect(find.text('المنزل'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    expect(find.text('حدث خطأ أثناء تحميل العناوين'), findsNothing);
    expect(find.text('المنزل'), findsOneWidget);
  });

  test('address list updates automatically from the repository stream, '
      'keeping exactly one default', () async {
    final controller = StreamController<List<AddressModel>>();
    final cubit = AddressCubit(
      repository: _FakeAddressRepository(controller),
    );

    final states = <AddressState>[];
    final stateSubscription = cubit.stream.listen(states.add);

    cubit.listenToAddresses();
    await pumpEventQueue();

    controller.add(const []);
    await pumpEventQueue();
    expect(states.last, isA<AddressEmpty>());

    final home = _address(title: 'المنزل', isDefault: true);
    controller.add([home]);
    await pumpEventQueue();
    expect(states.last, isA<AddressLoaded>());
    expect(_addressesOf(states.last), hasLength(1));

    final family = _address(title: 'بيت العائلة');
    controller.add([home, family]);
    await pumpEventQueue();
    final two = _addressesOf(states.last);
    expect(two, hasLength(2));
    expect(two.where((a) => a.isDefault), hasLength(1));

    final parentsHome = _address(title: 'منزل والدتي');
    controller.add([home, family, parentsHome]);
    await pumpEventQueue();
    final three = _addressesOf(states.last);
    expect(three, hasLength(3));
    expect(three.first.title, 'المنزل');
    expect(three.where((a) => a.isDefault), hasLength(1));

    await stateSubscription.cancel();
    await cubit.close();
    await controller.close();
  });
}

AddressModel _address({required String title, bool isDefault = false}) =>
    AddressModel(
      title: title,
      governorate: 'القاهرة',
      city: 'مدينة نصر',
      addressDetails: 'شارع عباس العقاد، عمارة 25، الدور 3',
      isDefault: isDefault,
      createdAt: DateTime(2026, 1, 1),
    );

List<AddressModel> _addressesOf(AddressState state) => switch (state) {
      AddressLoaded(:final addresses) => addresses,
      AddressActionInProgress(:final addresses) => addresses,
      AddressError(:final lastKnownAddresses) => lastKnownAddresses ?? const [],
      _ => const <AddressModel>[],
    };

class _FakeAddressRepository extends AddressRepository {
  _FakeAddressRepository(this.controller);

  final StreamController<List<AddressModel>> controller;

  @override
  Stream<List<AddressModel>> watchAddresses() => controller.stream;
}