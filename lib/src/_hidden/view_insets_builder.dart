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

import 'dart:ui';

import 'package:flutter/widgets.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ViewInsetsBuilder extends StatefulWidget {
  //
  //
  //

  final Widget? child;

  //
  //
  //

  final Widget Function(ViewInsetsBuilderParams params) builder;

  //
  //
  //

  const ViewInsetsBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  //
  //
  //

  @override
  _State createState() => _State();
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _State extends State<ViewInsetsBuilder> with WidgetsBindingObserver {
  //
  //
  //

  var _viewInsets = ViewPadding.zero;
  late final Widget? _staticChild;

  //
  //
  //

  bool _hasReachedMax = false;
  bool _hasReachedMin = false;

  //
  //
  //

  @override
  void initState() {
    super.initState();
    _staticChild = widget.child;
    WidgetsBinding.instance.addObserver(this);
  }

  //
  //
  //

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateViewInsets();
  }

  //
  //
  //

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _updateViewInsets();
  }

  //
  //
  //

  void _updateViewInsets() {
    final viewInsets = View.of(context).viewInsets;
    final reachedMax = viewInsets.top > _viewInsets.top ||
        viewInsets.bottom > _viewInsets.bottom ||
        viewInsets.left > _viewInsets.left ||
        viewInsets.right > _viewInsets.right;
    final reachedMin = viewInsets.top == 0 &&
        viewInsets.bottom == 0 &&
        viewInsets.left == 0 &&
        viewInsets.right == 0;
    if ((reachedMax && !_hasReachedMax) || (reachedMin && !_hasReachedMin)) {
      setState(() {
        _viewInsets = viewInsets;
        _hasReachedMax = reachedMax;
        _hasReachedMin = reachedMin;
      });
    }
  }

  //
  //
  //

  @override
  Widget build(BuildContext context) {
    final params = ViewInsetsBuilderParams._(
      context: context,
      child: _staticChild,
      viewInsets: _viewInsets,
    );
    return widget.builder(params);
  }

  //
  //
  //

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ViewInsetsBuilderParams {
  //
  //
  //

  final BuildContext context;
  final Widget? child;
  final ViewPadding viewInsets;

  //
  //
  //

  const ViewInsetsBuilderParams._({
    required this.context,
    required this.child,
    required this.viewInsets,
  });
}
