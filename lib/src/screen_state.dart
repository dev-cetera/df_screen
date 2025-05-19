//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by dev-cetera.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

// ignore_for_file: invalid_use_of_visible_for_overriding_member

import 'package:df_pod/df_pod.dart';
import 'package:flutter/material.dart';

import 'package:df_debouncer/df_debouncer.dart';
import 'package:meta/meta.dart';

import '../df_screen.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract base class ScreenState<TScreen extends Screen, TExtra extends Object?,
    TController extends ScreenController<TExtra>> extends State<TScreen> {
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
    // If the key is null, just create a new currentcontroller.
    if (key == null) {
      this.c = this._createController();
    } else
    // If the key is not null, only create a newcontroller if one for the key
    //  does not already exist.
    {
      // If nocontroller already exist in the cache, set one up.
      if (_controllerCache[key] == null) {
        final controllerTimeout = widget.controllerTimeout;
        _controllerCache[key] = _ControllerCache(
          controller: this._createController(),
          // If a timeout is specified, set up a debouncer to dispose of the
          //Controller once the screen is disposed and after the timeout.
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
        // Reset the debouncer so that thecontroller will again only time out
        // after the screen is disposed and after the timeout.
        _controllerCache[key]?.debouncer?.cancel();
      }
      // Assign the currentcontroller from the cache.
      this.c = _controllerCache[key]?.controller as TController;
    }
  }

  /// Creates a new instance of [TController] from the current widget.
  TController _createController() {
    return (widget.createController(widget, this)..initController())
        as TController;
  }

  /// Stores all activecontrollers.
  static final _controllerCache = <Key, _ControllerCache>{};

  @protected
  @nonVirtual
  @override
  Widget build(BuildContext context) {
    return c.pExtra != null
        ? PodBuilder(
            pod: c.pExtra!,
            builder: (context, snapshot) => buildWidget(context),
          )
        : buildWidget(context);
  }

  @visibleForOverriding
  Widget buildWidget(BuildContext context) => const SizedBox();

  @mustCallSuper
  @override
  void dispose() async {
    // Call the debouncer to trigger the disposal of thecontroller after the
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

  const _ControllerCache({required this.controller, required this.debouncer});
}
