// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:indian_constitution_vault/main.dart';

void main() {
  testWidgets('App starts and shows home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(child: IndianConstitutionApp()),
    );

    // Verify that home screen title is present.
    expect(find.text('Indian Constitution Vault'), findsWidgets);
    expect(find.text('Your bilingual legal companion'), findsOneWidget);
    expect(find.text('Browse Acts'), findsOneWidget);
  });
}
