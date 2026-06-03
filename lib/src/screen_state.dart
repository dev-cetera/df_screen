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

// ignore_for_file: invalid_use_of_visible_for_overriding_member

import 'package:flutter/material.dart';

import 'package:df_debouncer/df_debouncer.dart';
import 'package:meta/meta.dart';

import '../df_screen.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract base class ScreenState<TScreen extends Screen,
    TController extends ScreenController> extends State<TScreen> {
  /// The current controller associated with this screen.
  late final TController c;

  @override
  void initState() {
    _initController();
    super.initState();
  }

  void _initController() {
    final key = widget.key;
    if (key == null) {
      // No key → no caching. Always create a fresh controller.
      c = _createController();
      return;
    }

    final existing = _controllerCache[key];
    if (existing == null) {
      // First time we see this key → create + cache.
      final controllerTimeout = widget.controllerTimeout;
      c = _createController();
      _controllerCache[key] = _ControllerCache(
        controller: c,
        // If a timeout is specified, set up a debouncer to dispose of the
        // controller after the screen is disposed and the timeout elapses.
        // A null timeout means "keep alive indefinitely".
        debouncer: controllerTimeout != null
            ? Debouncer(
                delay: controllerTimeout,
                onWaited: () {
                  final entry = _controllerCache.remove(key);
                  entry?.controller.dispose();
                },
              )
            : null,
        // Keep the latest TController type so we can guard the cast on reuse.
        typeCheck: (other) => other is TController,
      );
    } else {
      // Re-entering a cached controller. Cancel the pending dispose, rebind
      // the controller to the *current* widget/state, then expose it as `c`.
      existing.debouncer?.cancel();
      if (!existing.typeCheck(existing.controller)) {
        // Key collision with a different controller type. Replace the entry
        // with a fresh controller rather than blowing up at the `as` below.
        existing.controller.dispose();
        final controllerTimeout = widget.controllerTimeout;
        c = _createController();
        _controllerCache[key] = _ControllerCache(
          controller: c,
          debouncer: controllerTimeout != null
              ? Debouncer(
                  delay: controllerTimeout,
                  onWaited: () {
                    final entry = _controllerCache.remove(key);
                    entry?.controller.dispose();
                  },
                )
              : null,
          typeCheck: (other) => other is TController,
        );
        return;
      }
      existing.controller.superScreen = widget;
      existing.controller.superState = this;
      c = existing.controller as TController;
    }
  }

  /// Creates a new instance of [TController] from the current widget. The
  /// async init is kicked off here (unawaited) and exposed via
  /// [ScreenController.ready] for code that needs to gate on completion.
  TController _createController() {
    final controller = widget.createController(widget, this) as TController;
    // ignore: unawaited_futures
    controller.runInit();
    return controller;
  }

  /// Stores all active controllers, keyed by widget key.
  static final _controllerCache = <Key, _ControllerCache>{};

  /// Removes the controller associated with this screen from the cache and
  /// disposes it. Use this when you explicitly want to discard a cached
  /// controller (e.g. on logout) without waiting for [controllerTimeout].
  void removeControllerFromCache() {
    final key = widget.key;
    if (key == null) return;
    final entry = _controllerCache.remove(key);
    entry?.debouncer?.cancel();
    entry?.controller.dispose();
  }

  /// Disposes and removes **every** controller currently held in the
  /// process-wide cache. Useful for sign-out flows or test teardown.
  static void clearAllControllers() {
    final entries = _controllerCache.values.toList(growable: false);
    _controllerCache.clear();
    for (final entry in entries) {
      entry.debouncer?.cancel();
      entry.controller.dispose();
    }
  }

  /// Triggers a rebuild of this screen. Provided for controllers (which
  /// don't have direct access to [State.setState]) and other external
  /// callers. No-ops when the state is no longer mounted.
  void rebuildScreen() {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(() {});
    }
  }

  @protected
  @nonVirtual
  @override
  Widget build(BuildContext context) {
    return buildWidget(context);
  }

  @visibleForOverriding
  Widget buildWidget(BuildContext context) => const SizedBox();

  @mustCallSuper
  @override
  void dispose() {
    final key = widget.key;
    if (key != null) {
      final entry = _controllerCache[key];
      final debouncer = entry?.debouncer;
      if (debouncer != null) {
        // Schedule disposal after the configured timeout.
        debouncer.call();
      }
      // If debouncer is null (controllerTimeout was null), the controller is
      // kept indefinitely. Use [removeControllerFromCache] or
      // [clearAllControllers] to release it.
    }
    super.dispose();
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _ControllerCache {
  final ScreenController controller;
  final Debouncer? debouncer;
  final bool Function(ScreenController) typeCheck;

  const _ControllerCache({
    required this.controller,
    required this.debouncer,
    required this.typeCheck,
  });
}
