// Demonstrates the controller cache: setting a positive `controllerTimeout`
// keeps the controller (and its state) alive across short navigations away
// from the screen. Navigating back within the timeout window reuses the
// same controller — the counter resumes where it was left.
//
// Try: tap "increment", tap "leave", tap "back" — the counter is preserved.

import 'package:df_screen/df_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: _Host()));
}

class _Host extends StatefulWidget {
  const _Host();
  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  bool showCounter = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controller cache demo')),
      body: showCounter
          ? const CounterScreen(
              key: ValueKey('counter'),
              controllerTimeout: Duration(minutes: 5),
            )
          : Center(
              child: ElevatedButton(
                onPressed: () => setState(() => showCounter = true),
                child: const Text('Back to counter'),
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            onPressed: () => setState(() => showCounter = false),
            child: const Text('Leave the screen'),
          ),
        ),
      ),
    );
  }
}

base class CounterScreen extends Screen {
  const CounterScreen({super.key, super.controllerTimeout});

  @override
  State createState() => _CounterScreenState();

  @override
  ScreenController createController(Screen screen, ScreenState state) {
    return CounterController(screen, state);
  }
}

base class CounterController extends ScreenController {
  CounterController(super.superScreen, super.superState);

  // This survives navigating away + back if controllerTimeout > 0.
  int count = 0;

  void increment() {
    count++;
    superState!.rebuildScreen();
  }
}

base class _CounterScreenState
    extends ScreenState<CounterScreen, CounterController> {
  @override
  Widget buildWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Count: ${c.count}',
              style: Theme.of(context).textTheme.headlineMedium,),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: c.increment, child: const Text('Increment')),
        ],
      ),
    );
  }
}
