# After Code Review Report

**Scope:** post-audit assessment of the existing `lib/` codebase.

**Important:** no source fixes were requested or applied. “After” means after the audit was completed, not after code changes.

## Prioritized Recommendations

### Critical and High

No critical or high-severity issues found.

### Medium

#### M1. Clear the stale error expression when recovering from an error

- **Location:** `lib/main.dart:57-61` and `lib/main.dart:135-139`
- **Recommended fix:**

```dart
if (_hasError || _replaceDisplay) {
  _display = value == '.' ? '0.' : value;
  if (_hasError) _expression = '';
  _hasError = false;
  _replaceDisplay = false;
  return;
}
```

Apply the same `_expression = ''` reset in `_backspace` when clearing an error.

#### M2. Expand widget coverage for state transitions

- **Location:** `test/widget_test.dart:6-41`; relevant paths: `lib/main.dart:107-155`
- **Recommended tests:** divide-by-zero recovery, clear, backspace, sign toggle, percent, and chained operations.

```dart
testWidgets('new input clears the divide-by-zero message', (tester) async {
  await tester.pumpWidget(const CalculatorApp());
  for (final key in ['7', '÷', '0', '=', '4']) {
    await tester.tap(find.text(key));
    await tester.pump();
  }

  expect(find.text('Cannot divide by zero'), findsNothing);
});
```

### Low

#### L1. Replace implicit non-null contracts

- **Location:** `lib/main.dart:77`, `85`, `98-115`
- **Recommended fix:** pass `firstOperand` directly to `_calculate` rather than using `_firstOperand!` in its switch branches.

#### L2. Define a display policy for floating-point edge cases

- **Location:** `lib/main.dart:157-163`
- **Recommended fix:** normalize exponent notation for ordinary calculator-sized values, or use decimal arithmetic if exact base-10 calculations are required.

## Post-Audit Checks

| Area | Status |
| --- | --- |
| Source security | Pass |
| Resource lifecycle / memory leaks | Pass |
| Async `BuildContext` safety | Pass |
| Performance | Pass for the fixed-size calculator interface |
| Functional review | Needs M1 and M2 addressed or accepted |
| Local analyzer and tests | Blocked by Flutter lock / interrupted command |
| Dependency freshness | Blocked by pub.dev connectivity |

## Next Step

Address M1, add the M2 tests, then rerun `flutter analyze`, `dart pub outdated`, and `flutter test` after the Flutter lockfile and pub.dev connectivity issues are resolved.
