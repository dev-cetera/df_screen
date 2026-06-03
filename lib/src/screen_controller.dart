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

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../df_screen.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

base class ScreenController {
  /// The screen this controller is bound to. Mutable so the controller cache
  /// can rebind it to a new screen instance when a screen with the same key
  /// is recreated.
  Screen? superScreen;

  /// The state this controller is bound to. Mutable for the same reason as
  /// [superScreen].
  ScreenState? superState;

  final Completer<void> _readyCompleter = Completer<void>();

  /// Completes when [initController] finishes (or errors).
  ///
  /// Useful for tests, debounce barriers, and `await c.ready` in `build` to
  /// gate UI on async initialization. The completer is fired exactly once
  /// per controller instance.
  Future<void> get ready => _readyCompleter.future;

  /// `true` once [initController] has finished without throwing.
  bool get isReady => _readyCompleter.isCompleted;

  ScreenController(this.superScreen, this.superState);

  /// Called once when the controller is first created. Override to perform
  /// async setup. The returned future is awaited internally so [ready]
  /// resolves at the right moment.
  @mustCallSuper
  @visibleForOverriding
  Future<void> initController() async {}

  /// Runs [initController] and completes [ready]. Called once by the state
  /// when the controller is created — do not call this manually.
  @nonVirtual
  Future<void> runInit() async {
    if (_readyCompleter.isCompleted) return;
    try {
      await initController();
      _readyCompleter.complete();
    } catch (error, stackTrace) {
      _readyCompleter.completeError(error, stackTrace);
    }
  }

  /// Override to release any resources held by this controller. Called when
  /// the controller is evicted from the cache (or immediately when
  /// `controllerTimeout: Duration.zero`).
  @mustCallSuper
  @visibleForOverriding
  void dispose() {}
}
