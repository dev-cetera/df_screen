//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. See LICENSE file
// in root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:flutter/widgets.dart';

import '_hidden/_index.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum AppLayout {
  //
  //
  //

  WIDE,
  NARROW,
  MOBILE_HORIZONTAL,
  MOBILE;

  //
  //
  //

  static AppLayout currentScreenLayout() {
    final currentScreenCalculator = getCurrentScreenCalculator();
    final currentScreenLayout = fromScreenCalculator(currentScreenCalculator);
    return currentScreenLayout;
  }

  //
  //
  //

  static AppLayout fromScreenCalculator(ScreenCalculator calculator) {
    if (CurrentPlatform.isMobile) {
      if (calculator.isVertical) {
        return AppLayout.MOBILE;
      } else {
        return AppLayout.MOBILE_HORIZONTAL;
      }
    }
    if (calculator.isAspectRatioMobile && calculator.isVertical) {
      return AppLayout.NARROW;
    }
    return AppLayout.WIDE;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

ScreenCalculator getCurrentScreenCalculator() {
  final firstDisplay = WidgetsBinding.instance.platformDispatcher.displays.first;
  final displaySize = firstDisplay.size;
  final displayPixelRatio = firstDisplay.devicePixelRatio;
  final screenSize = displaySize / displayPixelRatio;
  return ScreenCalculator(
    screenSize.width,
    screenSize.height,
  );
}
