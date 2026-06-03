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

import '/src/_src.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Opinionated [AdaptiveScreenState] with the four default mixins applied:
///
/// - [MobileFrameWideLayoutScreenMixin] frames the screen inside a mobile-
///   shaped area on wide layouts.
/// - [DefaultScrollableAlignScreenMixin] wraps the body in a bouncing
///   [SingleChildScrollView] that dismisses the keyboard on drag.
/// - [DefaultPaddingScreenMixin] applies the package's default 28.sc / 112.sc
///   safe-area padding.
/// - [RotateIconHorizontalMobileLayoutScreenMixin] replaces horizontal-mobile
///   layouts with a rotate-phone icon.
///
/// Override individual hooks to customize further, or use [AdaptiveScreenState]
/// directly for full control with no opinionated defaults.
abstract base class DefaultAdaptiveScreenState<TScreen extends Screen,
        TController extends ScreenController>
    extends AdaptiveScreenState<TScreen, TController>
    with
        MobileFrameWideLayoutScreenMixin,
        DefaultScrollableAlignScreenMixin,
        DefaultPaddingScreenMixin,
        RotateIconHorizontalMobileLayoutScreenMixin {}
