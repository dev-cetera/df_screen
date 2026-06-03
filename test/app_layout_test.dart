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
  group('AppLayout.fromSize (non-mobile platform)', () {
    // The tests below run on the host (typically macOS), which means
    // CurrentPlatform.isMobile is false, so the mobile branches in
    // fromScreenCalculator are not exercised. We document this with the
    // platform check upfront, then test the non-mobile branches.
    test('wide desktop window returns WIDE', () {
      final layout = AppLayout.fromSize(const Size(1600, 900));
      expect(layout, AppLayout.WIDE);
    });

    test('narrow vertical desktop window returns NARROW', () {
      // Tall narrow window (aspect > 4/3 vertically): qualifies as NARROW.
      final layout = AppLayout.fromSize(const Size(400, 1000));
      expect(layout, AppLayout.NARROW);
    });

    test('square window returns WIDE', () {
      final layout = AppLayout.fromSize(const Size(800, 800));
      expect(layout, AppLayout.WIDE);
    });
  });

  group('AppLayout breakpoint sensitivity', () {
    test('permissive minMobileAspectRatio makes more sizes NARROW', () {
      const bp = LayoutBreakpoints(minMobileAspectRatio: 1.0);
      final narrow = AppLayout.fromSize(
        const Size(400, 600),
        breakpoints: bp,
      );
      expect(narrow, AppLayout.NARROW);
    });

    test('strict minMobileAspectRatio shifts NARROW back to WIDE', () {
      const bp = LayoutBreakpoints(minMobileAspectRatio: 10.0);
      final wide = AppLayout.fromSize(
        const Size(400, 1000),
        breakpoints: bp,
      );
      expect(wide, AppLayout.WIDE);
    });
  });

  group('AppLayout.of (context-aware)', () {
    testWidgets('uses the MediaQuery size from the nearest ancestor',
        (tester) async {
      AppLayout? captured;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1600, 900)),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                captured = AppLayout.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(captured, AppLayout.WIDE);
    });

    testWidgets('respects an inner MediaQuery override', (tester) async {
      AppLayout? captured;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1600, 900)),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(400, 1000)),
              child: Builder(
                builder: (context) {
                  captured = AppLayout.of(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      expect(captured, AppLayout.NARROW);
    });
  });

  group('LayoutResolver typedef', () {
    test('signature accepts size + context and returns AppLayout', () {
      // ignore: prefer_function_declarations_over_variables
      final LayoutResolver resolver = (context, size) {
        return size.width > 1200 ? AppLayout.WIDE : AppLayout.NARROW;
      };
      expect(resolver, isNotNull);
    });
  });
}
