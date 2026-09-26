import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_service/features/account_settings/about_app/presentation/screens/about_app_screen.dart';
import 'package:home_service/features/account_settings/addresses/data/models/address_model.dart';
import 'package:home_service/features/account_settings/addresses/data/repositories/address_repository.dart';
import 'package:home_service/features/account_settings/addresses/logic/cubit/address_cubit.dart';
import 'package:home_service/features/account_settings/addresses/presentation/screens/add_address_screen.dart';
import 'package:home_service/features/account_settings/addresses/presentation/widgets/saved_addresses_list.dart';
import 'package:home_service/features/account_settings/invite_friend/presentation/screens/invite_friend_screen.dart';
import 'package:home_service/features/account_settings/security_privacy/presentation/screens/security_privacy_screen.dart';

const _sizes = [
  Size(320, 480),
  Size(390, 844),
  Size(800, 1280),
];

void main() {
  for (final size in _sizes) {
    testWidgets('about app renders without exceptions at $size',
        (tester) async {
      await _pumpAt(tester, size, const AboutAppScreen());
      expect(tester.takeException(), isNull);
    });

    testWidgets('security & privacy renders without exceptions at $size',
        (tester) async {
      await _pumpAt(tester, size, const SecurityPrivacyScreen());
      expect(tester.takeException(), isNull);
    });

    testWidgets('invite friend renders without exceptions at $size',
        (tester) async {
      await _pumpAt(tester, size, const InviteFriendScreen());
      expect(tester.takeException(), isNull);
    });

    testWidgets('saved addresses list renders long text without overflow '
        'at $size', (tester) async {
      await _pumpAt(
        tester,
        size,
        MaterialApp(
          home: Scaffold(
            body: SavedAddressesList(
              addresses: [
                AddressModel(
                  id: 'addr-1',
                  title: 'المنزل الرئيسي للعائلة مع شقة ملحقة للضيوف المفضلين',
                  governorate: 'القاهرة الكبرى والجيزة وما حولها',
                  city: 'مدينة نصر شرق القاهرة بالقرب من ميدان روكسي',
                  addressDetails:
                      'شارع عباس العقاد أمام برج النيل، عمارة 25 الدور الثالث '
                      'شقة 14 وعلى يسارها الدور الأرضي',
                  landmark: 'بجوار مسجد السلام الكبير مباشرة',
                  isDefault: true,
                  createdAt: DateTime(2026, 1, 1),
                ),
              ],
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('add address form renders without overflow at $size',
        (tester) async {
      await _pumpAt(
        tester,
        size,
        MaterialApp(
          home: BlocProvider(
            create: (_) => AddressCubit(repository: _RecordingAddressRepository()),
            child: const AddAddressScreen(),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('إضافة عنوان'), findsOneWidget);
    });
  }
}

Future<void> _pumpAt(WidgetTester tester, Size size, Widget widget) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle();
}

class _RecordingAddressRepository extends AddressRepository {
  @override
  Stream<List<AddressModel>> watchAddresses() => const Stream.empty();
}