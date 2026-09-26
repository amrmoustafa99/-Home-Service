import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_service/features/app/temporary_bottom_nav_shell.dart';
import 'package:home_service/main.dart';

void main() {
  testWidgets('App opens on the first onboarding screen', (tester) async {
    await tester.pumpWidget(const HomeServiceApp());

    expect(find.text('التالي'), findsOneWidget);
  });

  testWidgets(
      'bottom navigation renders without overflow on small, normal, '
      'large phones and tablets', (tester) async {
    final sizes = <Size>[
      const Size(320, 480),
      const Size(360, 640),
      const Size(390, 844),
      const Size(430, 932),
      const Size(800, 1280),
    ];

    for (final size in sizes) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        MaterialApp(
          home: TemporaryBottomNavShell(
            pages: const [SizedBox(), SizedBox(), SizedBox(), SizedBox(), SizedBox()],
          ),
        ),
      );

      for (final tab in ['الرئيسية', 'الخدمات', 'الفني الذكي', 'حجوزاتي', 'الحساب']) {
        await tester.tap(find.text(tab));
        await tester.pump(const Duration(milliseconds: 250));
        expect(tester.takeException(), isNull,
            reason: 'overflow/flex exception on $size when tapping $tab');
      }
    }

    await tester.binding.setSurfaceSize(null);
  });
}