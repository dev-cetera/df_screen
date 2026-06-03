//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Copyright © dev-cetera.com & contributors.
//
// The use of this source code is governed by an MIT-style license described in
// the LICENSE file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:ui' show Size;

import 'package:flutter/widgets.dart'
    show BuildContext, MediaQuery, WidgetsBinding;

import '_utils/_utils.g.dart';
import 'layout_breakpoints.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum AppLayout {
  WIDE,
  NARROW,
  MOBILE_HORIZONTAL,
  MOBILE;

  /// Resolves the current layout from the *primary platform display*. Prefer
  /// [AppLayout.of] inside widget code so an embedded sub-window doesn't pick
  /// up the host window's dimensions.
  static AppLayout currentScreenLayout({LayoutBreakpoints? breakpoints}) {
    final calc = getCurrentScreenCalculator(breakpoints: breakpoints);
    return fromScreenCalculator(calc, breakpoints: breakpoints);
  }

  /// Resolves the current layout from the [MediaQuery] visible at [context].
  /// This is the recommended entry point inside any widget tree.
  static AppLayout of(BuildContext context, {LayoutBreakpoints? breakpoints}) {
    return fromSize(MediaQuery.sizeOf(context), breakpoints: breakpoints);
  }

  /// Resolves a layout from a raw [Size].
  static AppLayout fromSize(Size size, {LayoutBreakpoints? breakpoints}) {
    final calc = ScreenCalculator.fromSize(size, breakpoints: breakpoints);
    return fromScreenCalculator(calc, breakpoints: breakpoints);
  }

  /// Classifies a [ScreenCalculator] into an [AppLayout].
  ///
  /// - Mobile OS + vertical screen → [MOBILE]
  /// - Mobile OS + horizontal screen → [MOBILE_HORIZONTAL]
  /// - Non-mobile + mobile-shaped (narrow desktop window) → [NARROW]
  /// - Otherwise → [WIDE]
  static AppLayout fromScreenCalculator(
    ScreenCalculator calculator, {
    LayoutBreakpoints? breakpoints,
  }) {
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

ScreenCalculator getCurrentScreenCalculator({LayoutBreakpoints? breakpoints}) {
  final firstDisplay =
      WidgetsBinding.instance.platformDispatcher.displays.first;
  final displaySize = firstDisplay.size;
  final displayPixelRatio = firstDisplay.devicePixelRatio;
  final screenSize = displaySize / displayPixelRatio;
  return ScreenCalculator(
    screenSize.width,
    screenSize.height,
    breakpoints: breakpoints,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Strategy callback for screens that want to plug in a custom mapping from
/// screen [Size] to [AppLayout]. Returning `null` falls back to
/// [AppLayout.fromSize].
typedef LayoutResolver = AppLayout? Function(BuildContext context, Size size);
