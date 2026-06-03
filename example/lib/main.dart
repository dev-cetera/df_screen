// Chooser app — pick an example, see it run.
//
// Each example_*.dart in this directory has its own `main()` for direct
// experimentation. This file just bundles them behind a list UI.

import 'package:flutter/material.dart';

import 'example_01_minimal.dart' as ex01;
import 'example_04_default_adaptive.dart' as ex04;
import 'example_05_custom_breakpoints.dart' as ex05;
import 'example_06_controller_state.dart' as ex06;
import 'example_07_async_init.dart' as ex07;
import 'example_08_router_integration.dart' as ex08;
import 'example_09_side_modes.dart' as ex09;
import 'example_2.dart' as ex02;
import 'example_3.dart' as ex03;

void main() {
  runApp(const _Index());
}

class _Index extends StatelessWidget {
  const _Index();

  static final examples = <_Example>[
    _Example('01 — Minimal screen', (_) => const ex01.MinimalScreen()),
    _Example('02 — Scrollable header (legacy)', (_) => const ex02.ExampleScreen()),
    _Example('03 — Overlay layout (legacy)', (_) => const ex03.OverlayExampleScreen()),
    _Example('04 — DefaultAdaptiveScreenState', (_) => const ex04.OpinionatedScreen()),
    _Example('05 — Custom breakpoints', (_) => const ex05.TunedScreen()),
    _Example('06 — Controller cache + state', (_) => const ex06.CounterScreen(
          key: ValueKey('counter'),
          controllerTimeout: Duration(minutes: 5),
        ),),
    _Example('07 — Async controller init', (_) => const ex07.AsyncInitScreen()),
    _Example('08 — df_router integration', (_) => const ex08.MyApp()),
    _Example('09 — Side modes showcase', (_) => const ex09.SideModeShowcase()),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'df_screen examples',
      home: Scaffold(
        appBar: AppBar(title: const Text('df_screen examples')),
        body: ListView.builder(
          itemCount: examples.length,
          itemBuilder: (context, i) {
            final e = examples[i];
            return ListTile(
              title: Text(e.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: e.build),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _Example {
  const _Example(this.title, this.build);
  final String title;
  final WidgetBuilder build;
}
