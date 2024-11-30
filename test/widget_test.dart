import 'package:contact1313/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home Page loads and displays title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the home page title is displayed.
    expect(find.text('Flutter Demo Home Page'), findsOneWidget);
  });

  testWidgets('Floating button exists on Home Page', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify the floating button is present.
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Counter increments when the floating button is pressed', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify initial counter state.
    expect(find.text('0'), findsOneWidget);

    // Tap the floating button and trigger a frame.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify counter has incremented.
    expect(find.text('1'), findsOneWidget);
  });
}
