import 'package:flutter_test/flutter_test.dart';
import 'package:home_service/core/constants/app_constants.dart';
import 'package:home_service/main.dart';

void main() {
  testWidgets('App foundation loads', (WidgetTester tester) async {
    await tester.pumpWidget(const HomeServiceApp());

    expect(find.text(AppConstants.appName), findsWidgets);
  });
}
