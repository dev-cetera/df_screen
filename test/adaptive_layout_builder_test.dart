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
  group('AdaptiveLayoutBuilder', () {
    testWidgets('renders the body builder', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AdaptiveLayoutBuilder(
            bodyBuilder: _bodyBuilder,
          ),
        ),
      );
      expect(find.byKey(const Key('body')), findsOneWidget);
    });

    testWidgets('topSideBuilder is wrapped in a Stack', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AdaptiveLayoutBuilder(
            bodyBuilder: _bodyBuilder,
            topSideBuilder: (context, insets) {
              return Container(
                key: const Key('top'),
                color: const Color(0xFFFF0000),
              );
            },
          ),
        ),
      );
      expect(find.byKey(const Key('top')), findsOneWidget);
    });

    testWidgets('background and foreground builders are rendered',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AdaptiveLayoutBuilder(
            bodyBuilder: _bodyBuilder,
            backgroundBuilder: (context) =>
                const ColoredBox(key: Key('bg'), color: Color(0xFF000000)),
            foregroundBuilder: (context) =>
                const IgnorePointer(child: SizedBox.shrink(key: Key('fg'))),
          ),
        ),
      );
      expect(find.byKey(const Key('bg')), findsOneWidget);
      expect(find.byKey(const Key('fg')), findsOneWidget);
    });

    testWidgets(
        'layout-specific body builders override the default bodyBuilder',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1600, 900)),
            child: AdaptiveLayoutBuilder(
              bodyBuilder: _bodyBuilder,
              wideBodyBuilder: (context) =>
                  const Text('wide', textDirection: TextDirection.ltr),
            ),
          ),
        ),
      );
      expect(find.text('wide'), findsOneWidget);
    });
  });
}

Widget _bodyBuilder(BuildContext context) {
  return const KeyedSubtree(
    key: Key('body'),
    child: SizedBox.expand(),
  );
}
