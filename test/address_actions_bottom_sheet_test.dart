import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_service/features/account_settings/addresses/data/models/address_model.dart';
import 'package:home_service/features/account_settings/addresses/data/repositories/address_repository.dart';
import 'package:home_service/features/account_settings/addresses/logic/cubit/address_cubit.dart';
import 'package:home_service/features/account_settings/addresses/presentation/screens/add_address_screen.dart';
import 'package:home_service/features/account_settings/addresses/presentation/widgets/saved_addresses_list.dart';

void main() {
  testWidgets('kebab opens the actions sheet with all three actions',
      (tester) async {
    final repo = _RecordingAddressRepository();
    await tester.pumpWidget(
      _host(repo, [_address(id: 'addr-1', title: 'المنزل')]),
    );

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    expect(find.text('تعديل العنوان'), findsOneWidget);
    expect(find.text('جعله العنوان الأساسي'), findsOneWidget);
    expect(find.text('حذف العنوان'), findsOneWidget);
  });

  testWidgets('make-default action is hidden for the default address',
      (tester) async {
    final repo = _RecordingAddressRepository();
    await tester.pumpWidget(
      _host(
        repo,
        [_address(id: 'addr-1', title: 'المنزل', isDefault: true)],
      ),
    );

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    expect(find.text('جعله العنوان الأساسي'), findsNothing);
    expect(find.text('تعديل العنوان'), findsOneWidget);
    expect(find.text('حذف العنوان'), findsOneWidget);
  });

  testWidgets('make-default calls the cubit and confirms with a snackbar',
      (tester) async {
    final repo = _RecordingAddressRepository();
    await tester.pumpWidget(
      _host(
        repo,
        [_address(id: 'addr-2', title: 'بيت العائلة')],
      ),
    );

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    await tester.tap(find.text('جعله العنوان الأساسي'));
    await tester.pumpAndSettle();

    expect(repo.setDefaultCalls, ['addr-2']);
    expect(find.text('تم تعيين العنوان كأساسي'), findsOneWidget);
    expect(find.text('تعديل العنوان'), findsNothing);
  });

  testWidgets('delete asks for confirmation before deleting', (tester) async {
    final repo = _RecordingAddressRepository();
    await tester.pumpWidget(
      _host(
        repo,
        [_address(id: 'addr-1', title: 'المنزل', isDefault: true)],
      ),
    );

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    await tester.tap(find.text('حذف العنوان'));
    await tester.pumpAndSettle();

    expect(find.text('هل أنت متأكد من حذف هذا العنوان؟'), findsOneWidget);
    expect(repo.deleteCalls, isEmpty);

    await tester.tap(find.text('إلغاء'));
    await tester.pumpAndSettle();

    expect(repo.deleteCalls, isEmpty);
    expect(find.text('تعديل العنوان'), findsOneWidget);

    await tester.tap(find.text('حذف العنوان'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('حذف'));
    await tester.pumpAndSettle();

    expect(repo.deleteCalls, ['addr-1']);
    expect(find.text('تم حذف العنوان'), findsOneWidget);
    expect(find.text('تعديل العنوان'), findsNothing);
  });

  testWidgets('edit mode pre-fills the form and updates the same address id',
      (tester) async {
    final repo = _RecordingAddressRepository();

    final existing = AddressModel(
      id: 'addr-1',
      title: 'المنزل',
      governorate: 'القاهرة',
      city: 'مدينة نصر',
      addressDetails: 'شارع عباس العقاد، عمارة 25، الدور 3',
      landmark: 'بجوار مسجد السلام',
      isDefault: true,
      createdAt: DateTime(2026, 1, 1),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: AddressCubit(repository: repo),
          child: AddAddressScreen(existingAddress: existing),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('تعديل العنوان'), findsOneWidget);
    expect(find.text('حفظ التعديلات'), findsOneWidget);
    expect(find.text('المنزل'), findsOneWidget);
    expect(find.text('بجوار مسجد السلام'), findsOneWidget);
    expect(
      find.text('شارع عباس العقاد، عمارة 25، الدور 3'),
      findsOneWidget,
    );
    expect(find.text('القاهرة'), findsOneWidget);
    expect(find.text('مدينة نصر'), findsOneWidget);
    expect(find.byType(Switch), findsNothing);

    await tester.tap(find.text('حفظ التعديلات'));
    await tester.pump();

    expect(repo.updatedAddress?.id, 'addr-1');
    expect(repo.updatedAddress?.title, 'المنزل');
    expect(repo.updatedAddress?.governorate, 'القاهرة');
    expect(repo.updatedAddress?.city, 'مدينة نصر');
    expect(repo.updatedAddress?.isDefault, isTrue);
    expect(repo.addedAddress, isNull);
  });

  testWidgets('edit opens the add-address screen in edit mode', (tester) async {
    final repo = _RecordingAddressRepository();
    await tester.pumpWidget(
      _host(
        repo,
        [_address(id: 'addr-1', title: 'المنزل')],
      ),
    );

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    await tester.tap(find.text('تعديل العنوان'));
    await tester.pumpAndSettle();

    expect(find.byType(AddAddressScreen), findsOneWidget);
    expect(find.text('تعديل العنوان'), findsOneWidget);
    expect(find.text('حفظ التعديلات'), findsOneWidget);
  });

  testWidgets('add mode keeps the default toggle visible', (tester) async {
    final repo = _RecordingAddressRepository();
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: AddressCubit(repository: repo),
          child: AddAddressScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('إضافة عنوان'), findsOneWidget);
    expect(find.text('إضافة العنوان'), findsOneWidget);
    expect(find.text('تعيين كعنوان افتراضي'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
  });
}

Widget _host(AddressRepository repo, List<AddressModel> addresses) {
  return MaterialApp(
    home: BlocProvider(
      create: (_) => AddressCubit(repository: repo),
      child: Scaffold(
        body: SavedAddressesList(addresses: addresses),
      ),
    ),
  );
}

AddressModel _address({
  required String id,
  required String title,
  bool isDefault = false,
}) =>
    AddressModel(
      id: id,
      title: title,
      governorate: 'القاهرة',
      city: 'مدينة نصر',
      addressDetails: 'شارع عباس العقاد، عمارة 25، الدور 3',
      landmark: 'بجوار مسجد السلام',
      isDefault: isDefault,
      createdAt: DateTime(2026, 1, 1),
    );

class _RecordingAddressRepository extends AddressRepository {
  final List<String> setDefaultCalls = [];
  final List<String> deleteCalls = [];
  AddressModel? updatedAddress;
  AddressModel? addedAddress;

  @override
  Stream<List<AddressModel>> watchAddresses() => const Stream.empty();

  @override
  Future<void> addAddress(AddressModel address) async {
    addedAddress = address;
  }

  @override
  Future<void> updateAddress(AddressModel address) async {
    updatedAddress = address;
  }

  @override
  Future<void> setDefaultAddress(String addressId) async {
    setDefaultCalls.add(addressId);
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    deleteCalls.add(addressId);
  }
}