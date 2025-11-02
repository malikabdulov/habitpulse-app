import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habitpulse/main.dart';

void main() {
  testWidgets('Login screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const HabitPulseApp());

    expect(find.text('HabitPulse Login'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'TestUser');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Welcome'), findsOneWidget);
  });
}
