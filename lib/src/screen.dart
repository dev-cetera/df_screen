//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. Use of this
// source code is governed by an MIT-style license that can be found in the
// LICENSE file.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:df_screen_core/df_screen_core.dart';
import 'package:df_generate_dart_models_core/df_generate_dart_models_core.dart';
import 'package:flutter/widgets.dart' show StatefulWidget;

import '_index.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract base class Screen<TModelScreenConfiguration extends Model> extends StatefulWidget {
  //
  //
  //

  final ModelScreenConfiguration? configuration;
  final Duration? controllerCacheTimeout;

  //
  //
  //

  const Screen({
    super.key,
    this.configuration,
    this.controllerCacheTimeout = Duration.zero,
  });

  //
  //
  //

  ScreenController createController(
    Screen screen,
    ScreenView state,
  ) {
    return ScreenController(screen, state);
  }
}
