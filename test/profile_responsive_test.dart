import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_service/features/profile/data/models/profile_field.dart';
import 'package:home_service/features/profile/data/repositories/profile_repository.dart';
import 'package:home_service/features/profile/logic/cubit/profile_cubit.dart';
import 'package:home_service/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:home_service/features/profile/presentation/screens/profile_screen.dart';

class _FakeProfileRepository extends ProfileRepository {
  @override
  Future<Map<String, dynamic>?> fetchProfileData(String uid) async {
    return {
      ProfileField.name: 'Abdalrhman',
      ProfileField.phone: '+20123456789',
      ProfileField.email: 'test@example.com',
    };
  }
}

void main() {
  ProfileCubit buildCubit() => ProfileCubit(
        repository: _FakeProfileRepository(),
        currentUidProvider: () => 'test-uid',
      );

  Future<void> pumpScreen(WidgetTester tester, Widget screen, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => buildCubit()),
        ],
        child: MaterialApp(home: screen),
      ),
    );
    await tester.pumpAndSettle();
  }

  final sizes = <String, Size>{
    'small phone (320x568)': const Size(320, 568),
    'standard phone (375x667)': const Size(375, 667),
    'large phone (428x926)': const Size(428, 926),
    'tablet (768x1024)': const Size(768, 1024),
  };

  for (final entry in sizes.entries) {
    testWidgets('EditProfileScreen responsive at ${entry.key}', (tester) async {
      await pumpScreen(tester, const EditProfileScreen(), entry.value);
      expect(tester.takeException(), isNull,
          reason: 'overflow/layout error at ${entry.key}');
    });

    testWidgets('ProfileScreen responsive at ${entry.key}', (tester) async {
      await pumpScreen(tester, const ProfileScreen(), entry.value);
      expect(tester.takeException(), isNull,
          reason: 'overflow/layout error at ${entry.key}');
    });
  }
}
