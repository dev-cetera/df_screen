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

import 'package:flutter/widgets.dart' show StatefulWidget;
import 'package:df_router/df_router.dart';

import '_src.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract base class Screen<TExtra extends Object?> extends StatefulWidget
    with RouteWidgetMixin<TExtra> {
  //
  //
  //

  @override
  final RouteState<TExtra?>? routeState;

  /// How long the controller for this screen stays cached after [State.dispose].
  ///
  /// - [Duration.zero] (default): dispose the controller immediately.
  /// - Positive duration: keep the controller alive for that long so re-entering
  ///   the screen (with the same [Key]) reuses it.
  /// - `null`: keep the controller alive **indefinitely**. Cache entries are
  ///   only released via [ScreenState.removeControllerFromCache] or
  ///   [ScreenState.clearAllControllers]. Be deliberate — unique-keyed screens
  ///   accumulate in a static map and leak otherwise.
  ///
  /// The cache is keyed by `widget.key`. Screens without a [Key] are never
  /// cached and always create a fresh controller.
  final Duration? controllerTimeout;

  //
  //
  //

  const Screen({
    super.key,
    this.routeState,
    this.controllerTimeout = Duration.zero,
  });

  //
  //
  //

  ScreenController createController(Screen screen, ScreenState state) {
    return ScreenController(screen, state);
  }
}
