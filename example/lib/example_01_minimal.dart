// The absolute minimum a df_screen-based screen needs:
//   - a Screen subclass (the StatefulWidget)
//   - a ScreenState subclass (the rendering layer)
//   - a ScreenController subclass (where business logic lives)
//
// No adaptive layouts, no side panels, just lifecycle wiring.

import 'package:df_screen/df_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: MinimalScreen()));
}

base class MinimalScreen extends Screen {
  const MinimalScreen({super.key});

  @override
  State createState() => _MinimalScreenState();

  @override
  ScreenController createController(Screen screen, ScreenState state) {
    return MinimalController(screen, state);
  }
}

base class MinimalController extends ScreenController {
  MinimalController(super.superScreen, super.superState);

  int taps = 0;

  void onTap() {
    taps++;
    // ScreenState exposes rebuildScreen() for controllers to request a
    // rebuild without touching protected State APIs.
    superState!.rebuildScreen();
  }
}

base class _MinimalScreenState extends ScreenState<MinimalScreen, MinimalController> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Taps: ${c.taps}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: c.onTap, child: const Text('Tap me')),
          ],
        ),
      ),
    );
  }
}
