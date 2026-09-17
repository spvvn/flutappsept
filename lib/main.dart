import 'package:flutter/material.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Calculator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF111318),
          useMaterial3: true,
        ),
        home: const CalculatorPage(),
      );
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  String _expression = '';
  double? _firstOperand;
  String? _operator;
  bool _replaceDisplay = false;
  bool _hasError = false;

  void _press(String key) => setState(() {
        if (key == 'C') {
          _clear();
        } else if (key == '⌫') {
          _backspace();
        } else if (key == '±') {
          _toggleSign();
        } else if (key == '%') {
          _percent();
        } else if (key == '=') {
          _equals();
        } else if (_isOperator(key)) {
          _setOperator(key);
        } else {
          _appendNumber(key);
        }
      });

  bool _isOperator(String value) => const ['÷', '×', '−', '+'].contains(value);

  void _appendNumber(String value) {
    if (_hasError || _replaceDisplay) {
      _display = value == '.' ? '0.' : value;
      _hasError = false;
      _replaceDisplay = false;
      return;
    }
    if (value == '.' && _display.contains('.')) return;
    _display = _display == '0' && value != '.' ? value : '$_display$value';
  }

  void _setOperator(String nextOperator) {
    if (_hasError) return;
    final current = double.tryParse(_display);
    if (current == null) return;
    if (_operator != null && !_replaceDisplay) {
      if (!_calculate(current)) return;
    } else {
      _firstOperand = current;
    }
    _operator = nextOperator;
    _expression = '${_format(_firstOperand!)} $nextOperator';
    _replaceDisplay = true;
  }

  void _equals() {
    if (_hasError || _operator == null || _firstOperand == null) return;
    final current = double.tryParse(_display);
    if (current == null) return;
    final expression = '${_format(_firstOperand!)} $_operator ${_format(current)} =';
    if (_calculate(current)) {
      _expression = expression;
      _operator = null;
      _firstOperand = null;
      _replaceDisplay = true;
    }
  }

  bool _calculate(double secondOperand) {
    double result;
    switch (_operator) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '−':
        result = _firstOperand! - secondOperand;
        break;
      case '×':
        result = _firstOperand! * secondOperand;
        break;
      case '÷':
        if (secondOperand == 0) {
          _display = 'Error';
          _expression = 'Cannot divide by zero';
          _hasError = true;
          _operator = null;
          _firstOperand = null;
          return false;
        }
        result = _firstOperand! / secondOperand;
        break;
      default:
        return false;
    }
    _firstOperand = result;
    _display = _format(result);
    return true;
  }

  void _clear() {
    _display = '0';
    _expression = '';
    _firstOperand = null;
    _operator = null;
    _replaceDisplay = false;
    _hasError = false;
  }

  void _backspace() {
    if (_hasError || _replaceDisplay) {
      _display = '0';
      _hasError = false;
      _replaceDisplay = false;
    } else if (_display.length <= 1 || (_display.length == 2 && _display.startsWith('-'))) {
      _display = '0';
    } else {
      _display = _display.substring(0, _display.length - 1);
    }
  }

  void _toggleSign() {
    if (_hasError || _display == '0') return;
    _display = _display.startsWith('-') ? _display.substring(1) : '-$_display';
  }

  void _percent() {
    if (_hasError) return;
    final value = double.tryParse(_display);
    if (value != null) _display = _format(value / 100);
  }

  String _format(double value) {
    if (value.isInfinite || value.isNaN) return 'Error';
    if (value == value.truncateToDouble()) return value.toInt().toString();
    return value
        .toStringAsPrecision(12)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    const keys = [
      ['C', '±', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '−'],
      ['1', '2', '3', '+'],
      ['0', '.', '⌫', '='],
    ];
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Calculator',
                        style: TextStyle(color: Color(0xFFF5F7FA), fontSize: 22, fontWeight: FontWeight.w600)),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(_expression,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 20)),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(_display,
                          key: const Key('calculator-display'),
                          style: const TextStyle(color: Color(0xFFF9FAFB), fontSize: 64, fontWeight: FontWeight.w300)),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: keys
                          .map((row) => Expanded(
                                child: Row(
                                  children: row
                                      .map((key) => Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: _CalculatorButton(label: key, onPressed: () => _press(key)),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CalculatorButton extends StatelessWidget {
  const _CalculatorButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const operators = ['÷', '×', '−', '+', '='];
    const utility = ['C', '±', '%', '⌫'];
    final isOperator = operators.contains(label);
    final color = isOperator
        ? const Color(0xFFFF9F0A)
        : utility.contains(label)
            ? const Color(0xFF4A5568)
            : const Color(0xFF252A34);
    return Semantics(
      button: true,
      label: label == '⌫' ? 'Backspace' : label,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
