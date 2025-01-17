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

import 'dart:async' show Completer;
import 'dart:ui' as ui show Image;

import 'package:df_type/df_type.dart' show letAsOrNull;
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter/widgets.dart';

import 'image_painter.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Captures a screenshot of the widget associated with the given [captureKey]
/// and returns a [CustomPaint] widget of the same displaying the captured
/// image or `null` no capture is possible. The [quality] parameter can be used
/// to adjust the quality of the apture (`0.0 > quality <= 1.0`).
Future<CustomPaint?> captureWidget(
  GlobalKey captureKey,
  BuildContext context, {
  double quality = 1.0,
}) async {
  final pixelRatio = View.of(context).devicePixelRatio * quality;
  final imageCompleter = Completer<ui.Image?>();
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    ui.Image? image;
    final boundary = letAsOrNull<RenderRepaintBoundary>(
      captureKey.currentContext?.findRenderObject(),
    );
    if (boundary != null) {
      image = await boundary.toImage(pixelRatio: pixelRatio);
    }
    imageCompleter.complete(image);
  });

  final image = await imageCompleter.future;
  if (image != null) {
    final result = CustomPaint(
      painter: ImagePainter(image),
      size: Size(
        image.width.toDouble(),
        image.height.toDouble(),
      ),
    );
    return result;
  }
  return null;
}
