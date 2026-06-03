//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Copyright © dev-cetera.com & contributors.
// MIT license. See https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Tests for the MeasureSize render-object widget.

import 'package:df_screen/df_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MeasureSize', () {
    testWidgets('reports the initial child size once a frame is committed',
        (tester) async {
      Size? reported;
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: MeasureSize(
              onChange: (s) => reported = s,
              child: const SizedBox(width: 120, height: 80),
            ),
          ),
        ),
      );
      // The callback is fired via addPostFrameCallback.
      await tester.pump();
      expect(reported, const Size(120, 80));
    });

    testWidgets('reports size changes when child rebuilds at new size',
        (tester) async {
      final notifier = ValueNotifier<Size>(const Size(100, 60));
      addTearDown(notifier.dispose);

      final reported = <Size>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: ValueListenableBuilder<Size>(
              valueListenable: notifier,
              builder: (context, value, _) {
                return MeasureSize(
                  onChange: reported.add,
                  child: SizedBox(width: value.width, height: value.height),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump();

      notifier.value = const Size(220, 110);
      await tester.pump();
      await tester.pump();

      expect(reported, contains(const Size(100, 60)));
      expect(reported, contains(const Size(220, 110)));
    });

    testWidgets('skips redundant callbacks when the size has not changed',
        (tester) async {
      var fires = 0;
      Widget tree() => MaterialApp(
            home: Center(
              child: MeasureSize(
                onChange: (_) => fires++,
                child: const SizedBox(width: 50, height: 50),
              ),
            ),
          );
      await tester.pumpWidget(tree());
      await tester.pump();
      final fires1 = fires;
      // Another rebuild at the same size should not re-fire.
      await tester.pumpWidget(tree());
      await tester.pump();
      expect(fires, fires1);
    });
  });
}
