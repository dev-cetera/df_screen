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

void main() {
  group('ViewInsetsBuilder', () {
    testWidgets('builds at least once with the current view insets',
        (tester) async {
      ViewInsetsBuilderParams? captured;
      await tester.pumpWidget(
        MaterialApp(
          home: ViewInsetsBuilder(
            builder: (params) {
              captured = params;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pump();
      expect(captured, isNotNull);
    });

    testWidgets('the child param matches the static child passed at init',
        (tester) async {
      Widget? capturedChild;
      const sentinel = Text(
        'sentinel',
        textDirection: TextDirection.ltr,
      );
      await tester.pumpWidget(
        const MaterialApp(
          home: ViewInsetsBuilder(
            builder: _captureChildBuilder,
            child: sentinel,
          ),
        ),
      );
      // Re-pump to ensure didChangeDependencies has fired and
      // _staticChild is wired.
      await tester.pump();
      capturedChild = _lastCapturedChild;
      expect(capturedChild, isA<Text>());
      expect((capturedChild! as Text).data, 'sentinel');
    });
  });
}

Widget? _lastCapturedChild;

Widget _captureChildBuilder(ViewInsetsBuilderParams params) {
  _lastCapturedChild = params.child;
  return const SizedBox.shrink();
}
