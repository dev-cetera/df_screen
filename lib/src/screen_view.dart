//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

// ignore_for_file: invalid_use_of_visible_for_overriding_member

import 'package:flutter/material.dart';

import 'package:df_screen_core/df_screen_core.dart';
import 'package:df_cleanup/df_cleanup.dart';

import 'package:df_debouncer/df_debouncer.dart';

import '_index.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract base class ScreenView<
        TScreen extends Screen,
        TModelScreenConfiguration extends ModelScreenConfiguration,
        TController extends ScreenController<TModelScreenConfiguration>> extends State<TScreen>
    with DisposeMixin, WillDisposeMixin {
  //
  //
  //

  // ---------------------------------------------------------------------------

  /// The current ontroller associated with this screen.
  late final TController c;

  @override
  void initState() {
    this._initController();
    super.initState();
  }

  void _initController() {
    final key = widget.key;
    // If the key is null, just create a new current controller.
    if (key == null) {
      this.c = this._createController();
    } else
    // If the key is not null, only create a new controller if one for the key
    //  does not already exist.
    {
      // If no controller already exist in the cache, set one up.
      if (_controllerCache[key] == null) {
        final controllerTimeout = widget.controllerCacheTimeout;
        _controllerCache[key] = _ControllerCache(
          controller: this._createController(),
          // If a timeout is specified, set up a debouncer to dispose of the
          //controller once the screen is disposed and after the timeout.
          debouncer: controllerTimeout != null
              ? Debouncer(
                  delay: controllerTimeout,
                  onWaited: () {
                    this.c.dispose();
                    _controllerCache.remove(widget.key);
                  },
                )
              : null,
        );
      } else {
        // Reset the debouncer so that the controller will again only time out
        // after the screen is disposed and after the timeout.
        _controllerCache[key]?.debouncer?.cancel();
      }
      // Assign the current controller from the cache.
      this.c = _controllerCache[key]?.controller as TController;
    }
  }

  /// Creates a new instance of [TController] from the current widget.
  TController _createController() {
    return (widget.createController(widget, this)..initController()) as TController;
  }

  /// Stores all active controllers.
  static final _controllerCache = <Key, _ControllerCache>{};

  @mustCallSuper
  @override
  void dispose() async {
    // Call the debouncer to trigger the disposal of the controller after the
    // timeout.
    final key = widget.key;
    if (key != null) {
      _controllerCache[key]?.debouncer?.call();
    }
    super.dispose();
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _ControllerCache {
  //
  //
  //

  final ScreenController controller;
  final Debouncer? debouncer;

  //
  //
  //

  const _ControllerCache({
    required this.controller,
    required this.debouncer,
  });
}
