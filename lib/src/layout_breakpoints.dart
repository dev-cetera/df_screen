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

import 'package:flutter/foundation.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Configuration thresholds that drive layout classification across df_screen.
///
/// Replace [LayoutBreakpoints.global] near app startup to retune everything at
/// once, or pass a [LayoutBreakpoints] instance to the static helpers that
/// accept one (e.g. [AppLayout.fromSize], [ScreenCalculator.fromSize]).
@immutable
class LayoutBreakpoints {
  /// The shortest-side threshold (in logical pixels) below which a window is
  /// considered "mobile-sized" by [CurrentPlatform.isWindowSizeMobile].
  ///
  /// Defaults to 550 — the same cutoff Flutter's `flutter_layout_grid` and
  /// material adaptive guidance use for compact phone shells.
  final double mobileMaxShortestSide;

  /// The minimum aspect ratio (long-side / short-side) at which a window is
  /// considered to have a "mobile-shaped" form factor. Used to detect
  /// narrow desktop windows that should adopt mobile-style layouts.
  ///
  /// Defaults to 4/3 — wider than that is considered "narrow desktop".
  final double minMobileAspectRatio;

  const LayoutBreakpoints({
    this.mobileMaxShortestSide = 550.0,
    this.minMobileAspectRatio = 4.0 / 3.0,
  });

  /// The process-wide default. Override before runApp() to retune every
  /// layout-detection helper in df_screen.
  ///
  /// ```dart
  /// void main() {
  ///   LayoutBreakpoints.global = const LayoutBreakpoints(
  ///     mobileMaxShortestSide: 600,
  ///   );
  ///   runApp(const App());
  /// }
  /// ```
  static LayoutBreakpoints global = const LayoutBreakpoints();

  LayoutBreakpoints copyWith({
    double? mobileMaxShortestSide,
    double? minMobileAspectRatio,
  }) {
    return LayoutBreakpoints(
      mobileMaxShortestSide:
          mobileMaxShortestSide ?? this.mobileMaxShortestSide,
      minMobileAspectRatio: minMobileAspectRatio ?? this.minMobileAspectRatio,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayoutBreakpoints &&
          other.mobileMaxShortestSide == mobileMaxShortestSide &&
          other.minMobileAspectRatio == minMobileAspectRatio;

  @override
  int get hashCode => Object.hash(mobileMaxShortestSide, minMobileAspectRatio);
}
