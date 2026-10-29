import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders basic material scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Cinemapedia'),
          ),
        ),
      ),
    );

    expect(find.text('Cinemapedia'), findsOneWidget);
  });
}
