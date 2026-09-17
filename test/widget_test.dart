import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('calculator adds two values', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['7', '+', '5', '=']) {
      await tester.tap(find.text(key));
      await tester.pump();
    }
    expect(find.text('12'), findsOneWidget);
  });

  testWidgets('calculator reports division by zero', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['7', '÷', '0', '=']) {
      await tester.tap(find.text(key));
      await tester.pump();
    }
    expect(find.text('Error'), findsOneWidget);
  });
}
