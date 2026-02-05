import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:eventism/app.dart';

void main() {
  testWidgets('App renders home page', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: EventismApp(),
      ),
    );

    // Verify app title is shown
    expect(find.text('Eventism'), findsWidgets);
  });
}
