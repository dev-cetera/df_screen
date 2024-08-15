//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. Use of this
// source code is governed by an MIT-style license that can be found in the
// LICENSE file.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:async' show Completer;
import 'dart:ui' as ui show Image;
import 'dart:ui';

import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter/widgets.dart';

import 'image_painter.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Captures a screenshot of the widget associated with the given [captureKey]
/// and returns a [CustomPaint] widget of the same displaying the captured
/// image.  The [quality] parameter can be used to adjust the quality of the
/// capture (`0.0 > quality <= 1.0`).
Future<CustomPaint> captureWidget(
  GlobalKey captureKey,
  BuildContext context, {
  double quality = 1.0,
}) async {
  final pixelRatio = View.of(context).devicePixelRatio * quality;
  final imageCompleter = Completer<ui.Image>();
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final boundary = captureKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    imageCompleter.complete(image);
  });

  final image = await imageCompleter.future;
  final result = CustomPaint(
    painter: ImagePainter(image),
    size: Size(
      image.width.toDouble(),
      image.height.toDouble(),
    ),
  );
  return result;
}
