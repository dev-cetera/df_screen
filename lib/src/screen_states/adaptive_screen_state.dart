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

import 'package:flutter/material.dart';

import 'package:meta/meta.dart';

import '../../df_screen.dart';
import '../_hidden/_index.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract base class AdaptiveScreenState<TScreen extends Screen,
        TExtra extends Object?, TController extends ScreenController<TExtra>>
    extends ScreenState<TScreen, TExtra, TController> {
  //
  //
  //

  // ---------------------------------------------------------------------------
  // Create a display structure for the screen.
  // ---------------------------------------------------------------------------

  /// Do not override. This method invokes the necessary builders and organizes
  /// the screen layout based on the current device.
  @protected
  @nonVirtual
  @override
  Widget buildScreen(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final calculator = ScreenCalculator(screenSize.width, screenSize.height);
    final appLayout = AppLayout.fromScreenCalculator(calculator);
    switch (appLayout) {
      case AppLayout.MOBILE:
        final body0 = this.mobileBody(context);
        final body5 = this._final(context, body0);
        final layout = this.mobileLayout(context, body5);
        return layout;
      case AppLayout.MOBILE_HORIZONTAL:
        final body0 = this.horizontalMobileBody(context);
        final body5 = this._final(context, body0);
        final layout = this.horizontalMobileLayout(context, body5);
        return layout;
      case AppLayout.NARROW:
        final body0 = this.narrowBody(context);
        final body5 = this._final(context, body0);
        final layout = this.narrowLayout(context, body5);
        return layout;
      case AppLayout.WIDE:
        final body0 = this.wideBody(context);
        final body5 = this._final(context, body0);
        final layout = this.wideLayout(context, body5);
        return layout;
    }
  }

  //
  //
  //

  /// Activates for mobile device screen sizes. Override to customize the
  /// layout for these sizes. The [body] includes the widget returned by
  /// [mobileLayout].
  Widget mobileLayout(BuildContext context, Widget body) {
    return this.narrowLayout(context, body);
  }

  /// Activates for mobile device screen sizes ith a horizontal orientation.
  /// Override to customize the layout for these sizes. The [body] includes the
  /// widget returned by [horizontalMobileBody].
  Widget horizontalMobileLayout(BuildContext context, Widget body) {
    return this.horizontalMobileBody(context);
  }

  /// Activates for non-mobile narrow screen sizes, such as a narrow desktop
  /// window or screen. Override to customize the layout for these sizes. The
  /// [body] includes the widget returned by [narrowBody].
  Widget narrowLayout(BuildContext context, Widget body) {
    return this.layout(context, body);
  }

  /// Activates for non-mobile wide screen sizes, such as a wide desktop
  /// window or screen. Override to customize the layout for these sizes. The
  /// [body] includes the widget returned by [wideBody].
  Widget wideLayout(BuildContext context, Widget body) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxHeight / MIN_MOBILE_ASPECT_RATIO,
                maxHeight: double.infinity,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: MSurface(
                  borderRadius: BorderRadius.circular(14.0),
                  color: Colors.transparent,
                  child: this.layout(context, body),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Activates for screen sizes that do not match the criteria for
  /// [mobileLayout], [horizontalMobileLayout], [narrowLayout], or [wideLayout].
  /// Override to customize these sizes. The [body] includes the widget returned
  /// by [this.body].
  Widget layout(BuildContext context, Widget body) {
    return body;
  }

  //
  //
  //

  /// Activates for mobile device screen sizes. Override to customize the  body
  /// for these sizes.
  Widget mobileBody(BuildContext context) {
    return this.narrowBody(context);
  }

  /// Activates for mobile device screen sizes ith a horizontal orientation.
  /// Override to customize the  body for these sizes.
  Widget horizontalMobileBody(BuildContext context) {
    return Center(
      child: Icon(
        Icons.rotate_90_degrees_ccw,
        size: 48.sc,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  /// Activates for non-mobile narrow screen sizes, such as a narrow desktop
  /// window or screen. Override to customize the  body for these sizes.
  Widget narrowBody(BuildContext context) {
    return this.body(context);
  }

  /// Activates for non-mobile wide screen sizes, such as a wide desktop
  /// window or screen. Override to customize the body for these sizes.
  Widget wideBody(BuildContext context) {
    return this.body(context);
  }

  /// Activates for screen sizes that do not match the criteria for
  /// [mobileLayout], [horizontalMobileLayout], [narrowLayout], or [wideLayout].
  /// Override to customize the body for these sizes.
  @visibleForOverriding
  Widget body(BuildContext context) {
    return const SizedBox.shrink();
  }

  //
  //
  //

  /// Override to specify the alignment of the [body] within the layout. Ideal
  /// for implementing scroll views. The [sideInsets] are set to correspond
  /// with the dimensions of widgets returned by [topSide], [bottomSide],
  /// [leftSide], and [rightSide].
  Widget align(
    BuildContext context,
    Widget body,
    EdgeInsets sideInsets,
  ) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: sideInsets,
          child: body,
        ),
      ),
    );
  }

  //
  //
  //

  /// Override to specify the padding for the body.
  EdgeInsets padding() {
    return EdgeInsets.only(
      top: 40.sc,
      left: 24.sc,
      right: 24.sc,
      bottom: 160.sc,
    );
  }

  /// Override to specify the side insets for the body. Side insets are
  /// applied to the top, bottom, left, and right of the body. They are
  /// added to the [padding].
  ///
  /// The [preferredInsets] are determined from [topSide],
  /// [bottomSide], [leftSide], and [rightSide].
  EdgeInsets sideInsets(EdgeInsets preferredInsets) {
    return preferredInsets;
  }

  //
  //
  //

  /// Override to specify the background. This is rendered behind the body.
  Widget background(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: const SizedBox.expand(),
    );
  }

  /// Override to specify the foregound. This is rendered over the body.
  ///
  /// Tip: Use an [IgnorePointer] when creating non-interactive overlays.
  Widget foreground(BuildContext context) {
    return const IgnorePointer(
      child: SizedBox.expand(),
    );
  }

  //
  //
  //

  /// Override to customize the top area of your screen.
  ///
  /// Tip: Ideal for placing elements like headers.
  Widget topSide(BuildContext context, double topInsets) {
    return const SizedBox.shrink();
  }

  /// Override to customize the bottom area of your screen.
  ///
  /// Tip: Ideal for placing elements like navigation controls.
  Widget bottomSide(BuildContext context, double bottomInsets) {
    return const SizedBox.shrink();
  }

  //// Override to customize the left area of your screen.
  ///
  /// Tip: Ideal for placing elements like menus and side panels.
  Widget leftSide(BuildContext context, double leftInsets) {
    return const SizedBox.shrink();
  }

  //// Override to customize the right area of your screen.
  ///
  /// Tip: Ideal for placing elements like menus and side panels.
  Widget rightSide(BuildContext context, double rightInsets) {
    return const SizedBox.shrink();
  }

  //
  //
  //

  /// Override to further define how the main [body], [background] and
  /// [foreground] are presented
  ///
  /// Tip: This is useful for showing or hiding the body content from the
  /// user or displaying loading indicators while the body content is being
  /// loaded.
  ///
  /// **Example:**
  ///
  /// ```dart
  /// @override
  /// Widget presentation(
  ///   BuildContext context,
  ///   Widget body,
  ///   Widget background,
  ///   Widget foreground,
  /// ) {
  ///   return PodBuilder(
  ///     pod: this._pIsLoading,
  ///     builder: (context, background, isLoading) {
  ///       if (isLoading) {
  ///         return Stack(
  ///           alignment: AlignmentDirectional.center,
  ///           fit: StackFit.expand,
  ///           children: [
  ///             background,
  ///             const CircularProgressIndicator(),
  ///           ],
  ///         );
  ///       } else {
  ///         return Stack(
  ///           alignment: AlignmentDirectional.center,
  ///           fit: StackFit.expand,
  ///          children: [
  ///             background,
  ///             body,
  ///             foreground,
  ///          ],
  ///         );
  ///       }
  ///     },
  ///     child: background,
  ///   );
  /// }
  /// ```
  Widget presentation(
    BuildContext context,
    Widget body,
    Widget background,
    Widget foreground,
  ) {
    return Stack(
      alignment: AlignmentDirectional.center,
      fit: StackFit.expand,
      children: [
        background,
        body,
        foreground,
      ],
    );
  }

  //
  //
  //

  /// Combines all the components into the final body.
  Widget _final(BuildContext context, Widget body0) {
    return ViewInsetsBuilder(
      builder: (params) {
        final topSide = this.topSide(context, params.viewInsets.top);
        final bottomSide = this.bottomSide(context, params.viewInsets.bottom);
        final leftSide = this.leftSide(context, params.viewInsets.left);
        final rightSide = this.rightSide(context, params.viewInsets.right);
        final body1 = Padding(
          padding: this.padding(),
          child: body0,
        );
        final body2 = this.align(
          context,
          body1,
          sideInsets(
            EdgeInsets.only(
              left: letAsOrNull<PreferredSizeWidget>(leftSide)
                      ?.preferredSize
                      .width ??
                  0.0,
              right: letAsOrNull<PreferredSizeWidget>(rightSide)
                      ?.preferredSize
                      .width ??
                  0.0,
              top: letAsOrNull<PreferredSizeWidget>(topSide)
                      ?.preferredSize
                      .height ??
                  0.0,
              bottom: letAsOrNull<PreferredSizeWidget>(bottomSide)
                      ?.preferredSize
                      .height ??
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
                        constraints: BoxConstraints.loose(
                          topSide.preferredSize,
                        ),
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

        final body4 = this.presentation(
          context,
          body3,
          this.background(context),
          this.foreground(context),
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
