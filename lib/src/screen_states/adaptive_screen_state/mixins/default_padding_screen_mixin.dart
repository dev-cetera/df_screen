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

import 'package:df_scalable/df_scalable.dart';
import 'package:flutter/material.dart';

import '../_adaptive_screen_state_interface.dart';

import '/src/_src.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Wraps the body in a [Padding] block sized by [defaultPaddingInsets].
///
/// Override [defaultPaddingInsets] (or [padding] directly) to retune the
/// safe-area inset that wraps your screen body without forking the mixin.
base mixin DefaultPaddingScreenMixin<TScreen extends Screen,
        TController extends ScreenController>
    on AdaptiveScreenStateInterface<TScreen, TController> {
  /// The insets applied by this mixin. Defaults to 28.sc on top/left/right
  /// and 112.sc on bottom (room for a tab bar / nav).
  EdgeInsets get defaultPaddingInsets => EdgeInsets.only(
        top: 28.sc,
        left: 28.sc,
        right: 28.sc,
        bottom: 112.sc,
      );

  @override
  Widget padding(BuildContext context, Widget child) {
    return Padding(
      padding: defaultPaddingInsets,
      child: child,
    );
  }
}
