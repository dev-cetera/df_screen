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

import 'package:flutter/material.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class Surface extends StatelessWidget {
  //
  //
  //

  final Widget? child;
  final BorderRadius borderRadius;
  final BoxConstraints? constraints;
  final BoxDecoration? decoration;
  final EdgeInsets? padding;
  final Color? color;
  final double? width;
  final double? height;

  //
  //
  //

  const Surface({
    super.key,
    this.child,
    this.borderRadius = BorderRadius.zero,
    this.constraints,
    this.decoration,
    this.padding,
    this.color,
    this.height,
    this.width,
  });

  //
  //
  //

  @override
  Widget build(BuildContext context) {
    final color1 =
        decoration?.color ?? color ?? Theme.of(context).colorScheme.surface;
    final borderRadius1 = decoration?.borderRadius ?? borderRadius;
    final decoration1 =
        decoration?.copyWith(color: color1, borderRadius: borderRadius1) ??
            BoxDecoration(color: color1, borderRadius: borderRadius1);
    return ClipRRect(
      borderRadius: borderRadius1,
      child: Container(
        width: width,
        height: height,
        constraints: constraints,
        decoration: decoration1,
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
