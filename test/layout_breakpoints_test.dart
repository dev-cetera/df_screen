//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Copyright © dev-cetera.com & contributors.
// MIT license. See https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:df_screen/df_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LayoutBreakpoints', () {
    tearDown(() {
      // Restore defaults so tests don't leak global state.
      LayoutBreakpoints.global = const LayoutBreakpoints();
    });

    test('default values', () {
      const bp = LayoutBreakpoints();
      expect(bp.mobileMaxShortestSide, 550.0);
      expect(bp.minMobileAspectRatio, 4.0 / 3.0);
    });

    test('custom values are stored verbatim', () {
      const bp = LayoutBreakpoints(
        mobileMaxShortestSide: 700,
        minMobileAspectRatio: 1.5,
      );
      expect(bp.mobileMaxShortestSide, 700);
      expect(bp.minMobileAspectRatio, 1.5);
    });

    test('copyWith retains untouched fields', () {
      const original = LayoutBreakpoints(
        mobileMaxShortestSide: 700,
        minMobileAspectRatio: 1.5,
      );
      final copy = original.copyWith(mobileMaxShortestSide: 800);
      expect(copy.mobileMaxShortestSide, 800);
      expect(copy.minMobileAspectRatio, 1.5);
    });

    test('value equality + hashCode', () {
      const a = LayoutBreakpoints(mobileMaxShortestSide: 600);
      const b = LayoutBreakpoints(mobileMaxShortestSide: 600);
      const c = LayoutBreakpoints(mobileMaxShortestSide: 700);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });

    test('global default is mutable and resets cleanly', () {
      const original = LayoutBreakpoints();
      expect(LayoutBreakpoints.global, equals(original));

      LayoutBreakpoints.global = const LayoutBreakpoints(
        mobileMaxShortestSide: 900,
      );
      expect(LayoutBreakpoints.global.mobileMaxShortestSide, 900);

      LayoutBreakpoints.global = const LayoutBreakpoints();
      expect(LayoutBreakpoints.global, equals(original));
    });
  });
}
