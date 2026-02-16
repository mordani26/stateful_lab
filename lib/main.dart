import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful Lab',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CounterWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  static const int _maxLimit = 100; 
  int _counter = 0;

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Color _getCounterColor() {
    if (_counter == 0) return Colors.red;
    if (_counter > 50) return Colors.green;
    return Colors.black;
  }

  void _increment() {
    setState(() {
      if (_counter < _maxLimit) _counter++;
    });
    if (_counter == _maxLimit) _showSnack("Limit Reached!");
  }

  void _decrement() {
    setState(() {
      if (_counter > 0) _counter--;
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
    });
  }

  void _setValueFromInput() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      _showSnack("Enter a number first.");
      return;
    }

    final value = int.tryParse(text);
    if (value == null) {
      _showSnack("Please enter a valid whole number.");
      return;
    }

    if (value > _maxLimit) {
      setState(() => _counter = _maxLimit);
      _showSnack("Limit Reached!");
      return;
    }

    if (value < 0) {
      setState(() => _counter = 0);
      _showSnack("Counter can’t go below 0.");
      return;
    }

    setState(() => _counter = value);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Counter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: double.infinity,
                color: Colors.blue.shade100,
                padding: const EdgeInsets.all(20),
                child: Text(
                  '$_counter',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50.0,
                    color: _getCounterColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Slider(
              min: 0,
              max: _maxLimit.toDouble(),
              divisions: _maxLimit,
              value: _counter.toDouble(),
              label: '$_counter',
              onChanged: (double value) {
                setState(() {
                  _counter = value.toInt();
                });
              },
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _decrement, child: const Text('-1')),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _increment, child: const Text('+1')),
                const SizedBox(width: 10),
                OutlinedButton(onPressed: _reset, child: const Text('Reset')),
              ],
            ),

            const SizedBox(height: 28),

            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Set counter (0 - $_maxLimit)',
                hintText: 'Type a number',
              ),
              onSubmitted: (_) => _setValueFromInput(),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _setValueFromInput,
              child: const Text('Set Value'),
            ),
          ],
        ),
      ),
    );
  }
}
