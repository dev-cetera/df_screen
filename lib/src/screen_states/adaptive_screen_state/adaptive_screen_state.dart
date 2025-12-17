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

// ignore_for_file: invalid_use_of_visible_for_overriding_member

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart' show nonVirtual;

import '../../_utils/_utils.g.dart';
import '/src/_src.g.dart';
import '_adaptive_screen_state_interface.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract base class AdaptiveScreenState<TScreen extends Screen,
        TController extends ScreenController>
    extends AdaptiveScreenStateInterface<TScreen, TController>
    with
        MobileFrameWideLayoutScreenMixin,
        DefaultScrollableAlignScreenMixin,
        DefaultPaddingScreenMixin,
        RotateIconHorizontalMobileLayoutScreenMixin {
  var _topSize = 0.0;
  var _bottomSize = 0.0;
  var _leftSize = 0.0;
  var _rightSize = 0.0;
  double get topSideSize => _topSize;
  double get bottomSideSize => _bottomSize;
  double get leftSideSize => _leftSize;
  double get rightSideSize => _rightSize;

  late final ScrollController bodyScrollController;

  @override
  void initState() {
    super.initState();
    bodyScrollController = ScrollController();
  }

  @override
  void dispose() {
    bodyScrollController.dispose();
    super.dispose();
  }

  double get minTopSideSize => kToolbarHeight;
  double get minBottomSideSize => 0.0;
  double get minLeftSideSize => 0.0;
  double get minRightSideSize => 0.0;

  @override
  Widget padding(BuildContext context, Widget child) {
    return Padding(padding: EdgeInsets.zero, child: child);
  }

  @protected
  @nonVirtual
  @override
  Widget buildWidget(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final calculator = ScreenCalculator(screenSize.width, screenSize.height);
    final appLayout = AppLayout.fromScreenCalculator(calculator);

    switch (appLayout) {
      case AppLayout.MOBILE:
        return mobileLayout(context, _wrapBody0(context, mobileBody(context)));
      case AppLayout.MOBILE_HORIZONTAL:
        return horizontalMobileLayout(
          context,
          _wrapBody0(context, horizontalMobileBody(context)),
        );
      case AppLayout.NARROW:
        return narrowLayout(context, _wrapBody0(context, narrowBody(context)));
      case AppLayout.WIDE:
        return wideLayout(context, _wrapBody0(context, wideBody(context)));
    }
  }

  void _updateSize(_ScreenSide side, Size size) {
    final newSize = (side == _ScreenSide.TOP || side == _ScreenSide.BOTTOM)
        ? size.height
        : size.width;

    var changed = false;
    switch (side) {
      case _ScreenSide.TOP:
        if (_topSize != newSize) {
          _topSize = newSize;
          changed = true;
        }
        break;
      case _ScreenSide.BOTTOM:
        if (_bottomSize != newSize) {
          _bottomSize = newSize;
          changed = true;
        }
        break;
      case _ScreenSide.LEFT:
        if (_leftSize != newSize) {
          _leftSize = newSize;
          changed = true;
        }
        break;
      case _ScreenSide.RIGHT:
        if (_rightSize != newSize) {
          _rightSize = newSize;
          changed = true;
        }
        break;
    }

    if (changed) setState(() {});
  }

  Widget _wrapBody0(BuildContext context, Widget body0) {
    return ViewInsetsBuilder(
      builder: (params) {
        final wTop = topSide(context, params.viewInsets.top);
        final wBottom = bottomSide(context, params.viewInsets.bottom);
        final wLeft = leftSide(context, params.viewInsets.left);
        final wRight = rightSide(context, params.viewInsets.right);

        Widget wrapMeasure(
          Widget child,
          _ScreenSide side,
          AdaptiveScreenSideMode mode,
        ) {
          if (mode != AdaptiveScreenSideMode.STATIC) {
            return MeasureSize(
              onChange: (e) => _updateSize(side, e),
              child: child,
            );
          }
          return child;
        }

        final mTop = wrapMeasure(wTop, _ScreenSide.TOP, topSideMode);
        final mBottom = wrapMeasure(
          wBottom,
          _ScreenSide.BOTTOM,
          bottomSideMode,
        );
        final mLeft = wrapMeasure(wLeft, _ScreenSide.LEFT, leftSideMode);
        final mRight = wrapMeasure(wRight, _ScreenSide.RIGHT, rightSideMode);

        var pTop = 0.0, pBottom = 0.0, pLeft = 0.0, pRight = 0.0;

        if (topSideMode == AdaptiveScreenSideMode.OVERLAY_WITH_PADDING) {
          pTop = _topSize > 0.0
              ? _topSize
              : (wTop is PreferredSizeWidget ? wTop.preferredSize.height : 0.0);
        }

        if (bottomSideMode == AdaptiveScreenSideMode.OVERLAY_WITH_PADDING) {
          pBottom = _bottomSize > 0
              ? _bottomSize
              : (wBottom is PreferredSizeWidget
                  ? wBottom.preferredSize.height
                  : 0.0);
        }

        if (leftSideMode == AdaptiveScreenSideMode.OVERLAY_WITH_PADDING) {
          pLeft = _leftSize > 0.0
              ? _leftSize
              : (wLeft is PreferredSizeWidget
                  ? wLeft.preferredSize.width
                  : 0.0);
        }

        if (rightSideMode == AdaptiveScreenSideMode.OVERLAY_WITH_PADDING) {
          pRight = _rightSize > 0.0
              ? _rightSize
              : (wRight is PreferredSizeWidget
                  ? wRight.preferredSize.width
                  : 0.0);
        }

        final body1 = padding(context, body0);
        final body2 = align(
          context,
          Padding(padding: MediaQuery.of(context).padding, child: body1),
          sideInsets(
            EdgeInsets.only(
              left: pLeft,
              right: pRight,
              top: pTop,
              bottom: pBottom,
            ),
          ),
        );

        var centerLayout = Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (leftSideMode == AdaptiveScreenSideMode.STATIC) mLeft,
            Expanded(
              child: Column(
                children: [
                  if (topSideMode == AdaptiveScreenSideMode.STATIC) mTop,
                  Expanded(child: body2),
                  if (bottomSideMode == AdaptiveScreenSideMode.STATIC) mBottom,
                ],
              ),
            ),
            if (rightSideMode == AdaptiveScreenSideMode.STATIC) mRight,
          ],
        );

        final stackChildren = <Widget>[centerLayout];

        bool isStack(AdaptiveScreenSideMode mode) =>
            mode == AdaptiveScreenSideMode.OVERLAY ||
            mode == AdaptiveScreenSideMode.OVERLAY_WITH_PADDING ||
            mode == AdaptiveScreenSideMode.SLIVER;

        if (isStack(topSideMode) ||
            isStack(bottomSideMode) ||
            isStack(leftSideMode) ||
            isStack(rightSideMode)) {
          stackChildren.add(
            AnimatedBuilder(
              animation: bodyScrollController,
              builder: (context, child) {
                var scrollY = 0.0;
                var scrollX = 0.0;

                if (bodyScrollController.hasClients) {
                  try {
                    if (bodyScrollController.position.axis == Axis.vertical) {
                      scrollY = bodyScrollController.offset;
                    } else {
                      scrollX = bodyScrollController.offset;
                    }
                  } catch (_) {}
                }

                final animatedLayers = <Widget>[];

                if (isStack(topSideMode)) {
                  var yPos = 0.0;
                  if (topSideMode == AdaptiveScreenSideMode.SLIVER) {
                    final maxScroll = math.max(0.0, _topSize - minTopSideSize);
                    final offset = scrollY.clamp(0.0, maxScroll);
                    yPos = -offset;
                  }
                  animatedLayers.add(
                    Positioned(top: yPos, left: 0, right: 0, child: mTop),
                  );
                }

                if (isStack(bottomSideMode)) {
                  var bottomPos = 0.0;
                  if (bottomSideMode == AdaptiveScreenSideMode.SLIVER) {
                    bottomPos = 0;
                  }
                  animatedLayers.add(
                    Positioned(
                      bottom: bottomPos,
                      left: 0.0,
                      right: 0.0,
                      child: mBottom,
                    ),
                  );
                }

                if (isStack(leftSideMode)) {
                  var xPos = 0.0;
                  if (leftSideMode == AdaptiveScreenSideMode.SLIVER) {
                    final maxScroll = math.max(
                      0.0,
                      _leftSize - minLeftSideSize,
                    );
                    xPos = -scrollX.clamp(0.0, maxScroll);
                  }
                  animatedLayers.add(
                    Positioned(top: 0, bottom: 0, left: xPos, child: mLeft),
                  );
                }

                if (isStack(rightSideMode)) {
                  var rightPos = 0.0;
                  if (rightSideMode == AdaptiveScreenSideMode.SLIVER) {
                    final maxScroll = math.max(
                      0.0,
                      _rightSize - minRightSideSize,
                    );
                    rightPos = -scrollX.clamp(0.0, maxScroll);
                  }
                  animatedLayers.add(
                    Positioned(
                      top: 0.0,
                      bottom: 0.0,
                      right: rightPos,
                      child: mRight,
                    ),
                  );
                }

                return Stack(fit: StackFit.expand, children: animatedLayers);
              },
            ),
          );
        }

        return presentation(
          context,
          stackChildren.length > 1
              ? Stack(fit: StackFit.expand, children: stackChildren)
              : stackChildren.first,
          background(context),
          foreground(context),
        );
      },
    );
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum _ScreenSide { TOP, BOTTOM, LEFT, RIGHT }

enum AdaptiveScreenSideMode { STATIC, OVERLAY_WITH_PADDING, OVERLAY, SLIVER }
