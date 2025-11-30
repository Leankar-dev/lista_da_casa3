// ListaDaCasa Widget Test
// Developed by: Leankar.dev

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lista_da_casa3/app/app.dart';

void main() {
  testWidgets('ListaDaCasa app starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ListaDaCasaApp()));

    // Verify that splash screen appears
    await tester.pump();
  });
}
