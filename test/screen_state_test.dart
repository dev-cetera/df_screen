//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Copyright © dev-cetera.com & contributors.
// MIT license. See https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:df_screen/df_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_helpers.dart';

void main() {
  setUp(() {
    TestScreenState.reset();
    ScreenState.clearAllControllers();
  });
  tearDown(() {
    ScreenState.clearAllControllers();
  });

  group('No-key controllers (always fresh)', () {
    testWidgets('creates a fresh controller every mount when key is null',
        (tester) async {
      await tester.pumpWidget(wrapApp(const TestScreen()));
      expect(TestController.instances, 1);

      await tester.pumpWidget(wrapApp(const SizedBox()));
      await tester.pump();
      // No key → no cache; controller is created fresh next time.
      await tester.pumpWidget(wrapApp(const TestScreen()));
      expect(TestController.instances, 2);
    });
  });

  group('Keyed controllers with controllerTimeout: Duration.zero', () {
    testWidgets('disposes the controller as soon as the screen unmounts',
        (tester) async {
      const key = ValueKey('zero-timeout');
      await tester.pumpWidget(wrapApp(const TestScreen(key: key)));
      expect(TestController.instances, 1);
      expect(TestController.disposeCount, 0);

      // Unmount the screen; default timeout is Duration.zero so dispose fires
      // after the Debouncer's Timer.zero fires.
      await tester.pumpWidget(wrapApp(const SizedBox()));
      await tester.pump(const Duration(milliseconds: 16));
      expect(TestController.disposeCount, 1);
    });

    testWidgets('does NOT reuse the controller when the cache entry was '
        'already disposed', (tester) async {
      const key = ValueKey('zero-timeout-reuse');
      await tester.pumpWidget(wrapApp(const TestScreen(key: key)));
      await tester.pumpWidget(wrapApp(const SizedBox()));
      await tester.pump(const Duration(milliseconds: 16));
      expect(TestController.disposeCount, 1);

      await tester.pumpWidget(wrapApp(const TestScreen(key: key)));
      expect(TestController.instances, 2);

      // Drain pending Debouncer timer before the test exits.
      await tester.pumpWidget(wrapApp(const SizedBox()));
      ScreenState.clearAllControllers();
      await tester.pump(const Duration(seconds: 1));
    });
  });

  group('Keyed controllers with positive controllerTimeout', () {
    testWidgets('keeps the controller alive across re-entries within the '
        'timeout', (tester) async {
      const key = ValueKey('warm-cache');
      const widget = TestScreen(
        key: key,
        controllerTimeout: Duration(seconds: 30),
      );
      await tester.pumpWidget(wrapApp(widget));
      expect(TestController.instances, 1);

      await tester.pumpWidget(wrapApp(const SizedBox()));
      // Only advance 1s — well inside the 30s timeout.
      await tester.pump(const Duration(seconds: 1));
      expect(TestController.disposeCount, 0);

      await tester.pumpWidget(wrapApp(widget));
      // Same controller reused.
      expect(TestController.instances, 1);
      expect(TestController.disposeCount, 0);

      // Drain any remaining timers before the test ends so flutter_test
      // doesn't complain about pending Timers (the Debouncer may have one).
      await tester.pumpWidget(wrapApp(const SizedBox()));
      ScreenState.clearAllControllers();
      await tester.pump(const Duration(seconds: 60));
    });

    testWidgets('rebinds superScreen/superState on cache reuse',
        (tester) async {
      const key = ValueKey('rebind');
      late TestController createdController;

      await tester.pumpWidget(
        wrapApp(
          TestScreen(
            key: key,
            controllerTimeout: const Duration(seconds: 30),
            onBuildController: (c) {
              createdController = c;
            },
          ),
        ),
      );

      final firstScreen = createdController.superScreen;

      // Force a remount with a new widget instance under the same key.
      await tester.pumpWidget(wrapApp(const SizedBox()));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpWidget(
        wrapApp(
          const TestScreen(
            key: key,
            controllerTimeout: Duration(seconds: 30),
            bodyText: 'changed',
          ),
        ),
      );

      // Controller was reused (instance count is still 1).
      expect(TestController.instances, 1);
      // Its superScreen now points at the *new* screen instance.
      expect(createdController.superScreen, isNot(equals(firstScreen)));
      expect(
        (createdController.superScreen! as TestScreen).bodyText,
        'changed',
      );

      // Clean up pending timers.
      await tester.pumpWidget(wrapApp(const SizedBox()));
      ScreenState.clearAllControllers();
      await tester.pump(const Duration(seconds: 60));
    });
  });

  group('Keyed controllers with controllerTimeout: null (live forever)', () {
    testWidgets('keeps the controller cached indefinitely', (tester) async {
      const key = ValueKey('forever');
      const widget = TestScreen(key: key, controllerTimeout: null);

      await tester.pumpWidget(wrapApp(widget));
      expect(TestController.instances, 1);

      await tester.pumpWidget(wrapApp(const SizedBox()));
      // No debouncer to drain, no timers; long jump is safe.
      await tester.pump(const Duration(days: 1));
      expect(TestController.disposeCount, 0);

      await tester.pumpWidget(wrapApp(widget));
      expect(TestController.instances, 1);

      // Clean up before test exits.
      ScreenState.clearAllControllers();
    });
  });

  group('Cache cleanup APIs', () {
    testWidgets('removeControllerFromCache disposes + removes', (tester) async {
      const key = ValueKey('removeme');
      const widget = TestScreen(
        key: key,
        controllerTimeout: Duration(seconds: 30),
      );
      await tester.pumpWidget(wrapApp(widget));
      final element = tester.state(find.byType(TestScreen)) as TestScreenState;

      element.removeControllerFromCache();
      expect(TestController.disposeCount, 1);

      // Remount → a fresh controller is created.
      await tester.pumpWidget(wrapApp(const SizedBox()));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpWidget(wrapApp(widget));
      expect(TestController.instances, 2);

      // Drain pending Debouncer timer.
      await tester.pumpWidget(wrapApp(const SizedBox()));
      ScreenState.clearAllControllers();
      await tester.pump(const Duration(seconds: 60));
    });

    testWidgets('clearAllControllers disposes every cached entry',
        (tester) async {
      const widget = TestScreen(
        key: ValueKey('clearall'),
        controllerTimeout: Duration(seconds: 30),
      );
      await tester.pumpWidget(wrapApp(widget));
      expect(TestController.instances, 1);

      ScreenState.clearAllControllers();
      expect(TestController.disposeCount, 1);

      // Drain any pending Debouncer timers.
      await tester.pumpWidget(wrapApp(const SizedBox()));
      await tester.pump(const Duration(seconds: 60));
    });
  });
}
