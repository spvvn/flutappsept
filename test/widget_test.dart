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

  testWidgets('calculator subtracts two values', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['9', '−', '4', '=']) {
      await tester.tap(find.text(key));
      await tester.pump();
    }
    final display = tester.widget<Text>(find.byKey(const Key('calculator-display')));
    expect(display.data, '5');
  });

  testWidgets('calculator multiplies two values', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['6', '×', '7', '=']) {
      await tester.tap(find.text(key));
      await tester.pump();
    }
    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('calculator divides values with decimals', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['7', '÷', '2', '=']) {
      await tester.tap(find.text(key));
      await tester.pump();
    }
    expect(find.text('3.5'), findsOneWidget);
  });

}
