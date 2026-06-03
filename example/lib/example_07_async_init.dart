// Demonstrates how to gate UI on async work in a controller.
//   - `initController()` is awaited internally by the framework
//   - `ScreenController.ready` is the Future that completes when init finishes
//   - errors thrown from initController surface through `ready`

import 'package:df_screen/df_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: AsyncInitScreen()));
}

base class AsyncInitScreen extends Screen {
  const AsyncInitScreen({super.key});

  @override
  State createState() => _State();

  @override
  ScreenController createController(Screen screen, ScreenState state) {
    return _AsyncController(screen, state);
  }
}

base class _AsyncController extends ScreenController {
  _AsyncController(super.superScreen, super.superState);

  List<String> items = const [];

  @override
  Future<void> initController() async {
    await super.initController();
    // Simulate a slow fetch.
    await Future<void>.delayed(const Duration(seconds: 1));
    items = const ['Alpha', 'Beta', 'Gamma'];
  }
}

base class _State extends ScreenState<AsyncInitScreen, _AsyncController> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Async controller init')),
      body: FutureBuilder<void>(
        future: c.ready,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load: ${snapshot.error}'));
          }
          return ListView(
            children: [for (final item in c.items) ListTile(title: Text(item))],
          );
        },
      ),
    );
  }
}
