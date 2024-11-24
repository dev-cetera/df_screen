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

import 'package:df_pod/df_pod.dart';
import 'package:flutter/material.dart';

import 'package:df_debouncer/df_debouncer.dart';
import 'package:meta/meta.dart';

import '../df_screen.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract base class ScreenState<TScreen extends Screen, TExtra extends Object?,
    TConductor extends ScreenConductor<TExtra>> extends State<TScreen> {
  //
  //
  //

  // ---------------------------------------------------------------------------

  /// The current ontroller associated with this screen.
  late final TConductor c;

  @override
  void initState() {
    this._initConductor();
    super.initState();
  }

  void _initConductor() {
    final key = widget.key;
    // If the key is null, just create a new current Conductor.
    if (key == null) {
      this.c = this._createConductor();
    } else
    // If the key is not null, only create a new Conductor if one for the key
    //  does not already exist.
    {
      // If no Conductor already exist in the cache, set one up.
      if (_conductorCache[key] == null) {
        final ConductorTimeout = widget.conductorTimeout;
        _conductorCache[key] = _ConductorCache(
          Conductor: this._createConductor(),
          // If a timeout is specified, set up a debouncer to dispose of the
          //Conductor once the screen is disposed and after the timeout.
          debouncer: ConductorTimeout != null
              ? Debouncer(
                  delay: ConductorTimeout,
                  onWaited: () {
                    this.c.dispose();
                    _conductorCache.remove(widget.key);
                  },
                )
              : null,
        );
      } else {
        // Reset the debouncer so that the Conductor will again only time out
        // after the screen is disposed and after the timeout.
        _conductorCache[key]?.debouncer?.cancel();
      }
      // Assign the current Conductor from the cache.
      this.c = _conductorCache[key]?.Conductor as TConductor;
    }
  }

  /// Creates a new instance of [TConductor] from the current widget.
  TConductor _createConductor() {
    return (widget.createConductor(widget, this)..initConductor())
        as TConductor;
  }

  /// Stores all active Conductors.
  static final _conductorCache = <Key, _ConductorCache>{};

  @protected
  @nonVirtual
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      maintainBottomViewPadding: true,
      child: c.pExtra != null
          ? PodBuilder(
              pod: c.pExtra!,
              builder: (context, snapshot) => buildScreen(context),
            )
          : buildScreen(context),
    );
  }

  Widget buildScreen(BuildContext context);

  @mustCallSuper
  @override
  void dispose() async {
    // Call the debouncer to trigger the disposal of the Conductor after the
    // timeout.
    final key = widget.key;
    if (key != null) {
      _conductorCache[key]?.debouncer?.call();
    }
    super.dispose();
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _ConductorCache {
  //
  //
  //

  final ScreenConductor Conductor;
  final Debouncer? debouncer;

  //
  //
  //

  const _ConductorCache({
    required this.Conductor,
    required this.debouncer,
  });
}
