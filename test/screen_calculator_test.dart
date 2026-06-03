//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Copyright © dev-cetera.com & contributors.
// MIT license. See https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:ui' show Size;

import 'package:df_screen/df_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScreenCalculator', () {
    test('classifies a portrait phone as vertical with mobile aspect', () {
      final calc = ScreenCalculator(400, 800);
      expect(calc.width, 400);
      expect(calc.height, 800);
      expect(calc.longest, 800);
      expect(calc.shortest, 400);
      expect(calc.isVertical, isTrue);
      expect(calc.isHorizontal, isFalse);
      expect(calc.isNeitherHorizontalNorVertical, isFalse);
      expect(calc.isAspectRatioMobile, isTrue);
    });

    test('classifies a landscape phone as horizontal', () {
      final calc = ScreenCalculator(800, 400);
      expect(calc.isHorizontal, isTrue);
      expect(calc.isVertical, isFalse);
    });

    test('classifies a 1:1 square as neither', () {
      final calc = ScreenCalculator(500, 500);
      expect(calc.isNeitherHorizontalNorVertical, isTrue);
    });

    test('sizeVerticalBias picks long side as width', () {
      final calc = ScreenCalculator(400, 800);
      expect(calc.sizeVerticalBias.width, 800);
      expect(calc.sizeVerticalBias.height, 400);
    });

    test('isAspectRatioMobile is false for 4:3 tablet shapes', () {
      // 1024x768 tablet: aspect bias = 1024/768 = 1.333... = MIN_MOBILE_ASPECT_RATIO
      // The check is strict > so equals boundary is false.
      final calc = ScreenCalculator(768, 1024);
      expect(calc.isAspectRatioMobile, isFalse);
    });

    test('isAspectRatioMobile uses overridden breakpoints', () {
      final permissive = ScreenCalculator(
        768,
        1024,
        breakpoints: const LayoutBreakpoints(minMobileAspectRatio: 1.0),
      );
      expect(permissive.isAspectRatioMobile, isTrue);

      final strict = ScreenCalculator(
        320,
        800,
        breakpoints: const LayoutBreakpoints(minMobileAspectRatio: 10.0),
      );
      expect(strict.isAspectRatioMobile, isFalse);
    });

    test('fromSize convenience constructor', () {
      final calc = ScreenCalculator.fromSize(const Size(400, 800));
      expect(calc.width, 400);
      expect(calc.height, 800);
    });
  });

  group('ScreenSize.aspectRatio', () {
    test('returns width/height for normal sizes', () {
      const size = ScreenSize(800, 400);
      expect(size.aspectRatio, 2.0);
    });

    test('returns infinity for zero height with positive width', () {
      const size = ScreenSize(800, 0);
      expect(size.aspectRatio, double.infinity);
    });

    test('returns negativeInfinity for zero height with negative width', () {
      const size = ScreenSize(-1, 0);
      expect(size.aspectRatio, double.negativeInfinity);
    });

    test('returns 0 for zero-by-zero', () {
      const size = ScreenSize(0, 0);
      expect(size.aspectRatio, 0.0);
    });
  });

  group('CalculatorOnScreenSizeExtension', () {
    test('calculator getter returns a calculator with matching dimensions', () {
      const size = ScreenSize(400, 800);
      final calc = size.calculator;
      expect(calc.width, 400);
      expect(calc.height, 800);
    });
  });
}
