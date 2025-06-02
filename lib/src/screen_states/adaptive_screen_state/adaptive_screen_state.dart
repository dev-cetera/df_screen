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

import 'package:df_type/df_type.dart' show letAsOrNull;
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
  /// Do not override. This method invokes the necessary builders and organizes
  /// the screen layout based on the current device.
  @protected
  @nonVirtual
  @override
  Widget buildWidget(BuildContext context) {
    // return Column(
    //   children: [
    //     topSide(context, 0.0),
    //     Expanded(
    //       child: body(context),
    //     ),
    //     bottomSide(context, 0.0)
    //   ],
    // );
    // return AdaptiveLayoutBuilder(
    //   bodyBuilder: body,
    //   mobileLayoutBuilder: mobileLayout,
    //   horizontalMobileLayoutBuilder: horizontalMobileLayout,
    //   narrowLayoutBuilder: narrowLayout,
    //   wideLayoutBuilder: wideLayout,
    //   mobileBodyBuilder: mobileBody,
    //   horizontalMobileBodyBuilder: horizontalMobileBody,
    //   narrowBodyBuilder: narrowBody,
    //   wideBodyBuilder: wideBody,
    //   topSideBuilder: topSide,
    //   bottomSideBuilder: bottomSide,
    //   leftSideBuilder: leftSide,
    //   rightSideBuilder: rightSide,
    //   backgroundBuilder: background,
    //   foregroundBuilder: foreground,
    //   paddingBuilder: padding,
    // );
    final screenSize = MediaQuery.of(context).size;
    final calculator = ScreenCalculator(screenSize.width, screenSize.height);
    final appLayout = AppLayout.fromScreenCalculator(calculator);
    switch (appLayout) {
      case AppLayout.MOBILE:
        final body0 = mobileBody(context);
        final body1 = _wrapBody0(context, body0);
        final layout = mobileLayout(context, body1);
        return layout;
      case AppLayout.MOBILE_HORIZONTAL:
        final body0 = horizontalMobileBody(context);
        final body1 = _wrapBody0(context, body0);
        final layout = horizontalMobileLayout(context, body1);
        return layout;
      case AppLayout.NARROW:
        final body0 = narrowBody(context);
        final body1 = _wrapBody0(context, body0);
        final layout = narrowLayout(context, body1);
        return layout;
      case AppLayout.WIDE:
        final body0 = wideBody(context);
        final body1 = _wrapBody0(context, body0);
        final layout = wideLayout(context, body1);
        return layout;
    }
  }

  /// Combines all the components into the final body.
  Widget _wrapBody0(BuildContext context, Widget body0) {
    return ViewInsetsBuilder(
      builder: (params) {
        final topSide = this.topSide(context, params.viewInsets.top);
        final bottomSide = this.bottomSide(context, params.viewInsets.bottom);
        final leftSide = this.leftSide(context, params.viewInsets.left);
        final rightSide = this.rightSide(context, params.viewInsets.right);
        final body1 = padding(context, body0);
        final body2 = align(
          context,
          Padding(
            padding: MediaQuery.of(context).padding,
            child: body1,
          ),
          sideInsets(
            EdgeInsets.only(
              left: letAsOrNull<PreferredSizeWidget>(
                    leftSide,
                  )?.preferredSize.width ??
                  0.0,
              right: letAsOrNull<PreferredSizeWidget>(
                    rightSide,
                  )?.preferredSize.width ??
                  0.0,
              top: letAsOrNull<PreferredSizeWidget>(
                    topSide,
                  )?.preferredSize.height ??
                  0.0,
              bottom: letAsOrNull<PreferredSizeWidget>(
                    bottomSide,
                  )?.preferredSize.height ??
                  0.0,
            ),
          ),
        );
        final body3 = Stack(
          alignment: AlignmentDirectional.center,
          fit: StackFit.expand,
          children: [
            body2,
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                topSide is PreferredSizeWidget
                    ? ConstrainedBox(
                        constraints: BoxConstraints.loose(topSide.preferredSize),
                        child: topSide,
                      )
                    : topSide,
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      leftSide is PreferredSizeWidget
                          ? ConstrainedBox(
                              constraints: BoxConstraints.loose(
                                leftSide.preferredSize,
                              ),
                              child: leftSide,
                            )
                          : leftSide,
                      rightSide is PreferredSizeWidget
                          ? ConstrainedBox(
                              constraints: BoxConstraints.loose(
                                rightSide.preferredSize,
                              ),
                              child: rightSide,
                            )
                          : rightSide,
                    ],
                  ),
                ),
                bottomSide is PreferredSizeWidget
                    ? ConstrainedBox(
                        constraints: BoxConstraints.loose(
                          bottomSide.preferredSize,
                        ),
                        child: bottomSide,
                      )
                    : bottomSide,
              ],
            ),
          ],
        );

        final body4 = presentation(
          context,
          body3,
          background(context),
          foreground(context),
        );
        final body5 = ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: body4,
        );
        return body5;
      },
    );
  }
}
