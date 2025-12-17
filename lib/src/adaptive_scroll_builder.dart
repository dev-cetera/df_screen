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

import 'package:flutter/widgets.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class AdaptiveScrollBuilder extends StatelessWidget {
  final ScrollController controller;
  final double expandedSize;
  final double collapsedSize;
  final Widget Function(BuildContext context, double percentage, Widget? child)
      builder;
  final Widget? child;

  const AdaptiveScrollBuilder({
    super.key,
    required this.controller,
    required this.expandedSize,
    required this.collapsedSize,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final offset = controller.hasClients ? controller.offset : 0.0;
        final range = expandedSize - collapsedSize;
        final t = range == 0 ? 1.0 : (1.0 - (offset / range)).clamp(0.0, 1.0);
        return builder(context, t, child);
      },
      child: child,
    );
  }
}
