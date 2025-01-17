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

import 'package:df_pod/df_pod.dart';
import 'package:flutter/foundation.dart';

import '../df_screen.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

base class ScreenController<TExtra extends Object?> {
  //
  //
  //

  final Screen? superScreen;
  final ScreenState? superState;
  final RootPod<TExtra>? pExtra;

  //
  //
  //

  ScreenController(
    this.superScreen,
    this.superState, [
    TExtra? extra,
  ]) : pExtra = extra != null ? RootPod(extra) : null;

  //
  //
  //

  @mustCallSuper
  @visibleForOverriding
  void initController() async {}

  //
  //
  //

  @mustCallSuper
  @visibleForOverriding
  void dispose() {
    pExtra?.dispose();
  }
}
