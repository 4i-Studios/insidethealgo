// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:InsideTheAlgo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Algorithm list page loads with header', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BubbleSortApp());
    await tester.pumpAndSettle();

    expect(find.text('Algorithm Visualizer'), findsOneWidget);
    expect(find.text('Select Algorithm Category'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
