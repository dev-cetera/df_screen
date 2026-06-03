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

import 'package:flutter/material.dart';

import '/src/_src.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Override hooks for an [AdaptiveScreenState]. Every method has a sensible
/// default — typical screens only override [body] (and maybe [topSide],
/// [layout], [align], [padding] as needed).
abstract base class AdaptiveScreenStateInterface<TScreen extends Screen,
        TController extends ScreenController>
    extends ScreenState<TScreen, TController> {
  /// Activates for mobile device screen sizes. Override to customize the
  /// layout for these sizes. The [body] includes the widget returned by
  /// [mobileBody].
  @pragma('vm:prefer-inline')
  Widget mobileLayout(BuildContext context, Widget body) {
    return narrowLayout(context, body);
  }

  /// Activates for mobile device screen sizes with a horizontal orientation.
  /// Override to customize the layout for these sizes. The [body] includes the
  /// widget returned by [horizontalMobileBody].
  @pragma('vm:prefer-inline')
  Widget horizontalMobileLayout(BuildContext context, Widget body) {
    return wideLayout(context, body);
  }

  /// Activates for non-mobile narrow screen sizes, such as a narrow desktop
  /// window or screen. Override to customize the layout for these sizes. The
  /// [body] includes the widget returned by [narrowBody].
  @pragma('vm:prefer-inline')
  Widget narrowLayout(BuildContext context, Widget body) {
    return layout(context, body);
  }

  /// Activates for non-mobile wide screen sizes, such as a wide desktop
  /// window or screen. Override to customize the layout for these sizes. The
  /// [body] includes the widget returned by [wideBody].
  @pragma('vm:prefer-inline')
  Widget wideLayout(BuildContext context, Widget body) {
    return layout(context, body);
  }

  /// Activates for screen sizes that do not match the criteria for
  /// [mobileLayout], [horizontalMobileLayout], [narrowLayout], or [wideLayout].
  /// Override to customize these sizes. The [body] includes the widget returned
  /// by [body].
  @pragma('vm:prefer-inline')
  Widget layout(BuildContext context, Widget body) {
    return body;
  }

  /// Activates for mobile device screen sizes. Override to customize the body
  /// for these sizes.
  @pragma('vm:prefer-inline')
  Widget mobileBody(BuildContext context) {
    return narrowBody(context);
  }

  /// Activates for mobile device screen sizes with a horizontal orientation.
  /// Override to customize the body for these sizes.
  @pragma('vm:prefer-inline')
  Widget horizontalMobileBody(BuildContext context) {
    return wideBody(context);
  }

  /// Activates for non-mobile narrow screen sizes, such as a narrow desktop
  /// window or screen. Override to customize the body for these sizes.
  @pragma('vm:prefer-inline')
  Widget narrowBody(BuildContext context) {
    return body(context);
  }

  /// Activates for non-mobile wide screen sizes, such as a wide desktop
  /// window or screen. Override to customize the body for these sizes.
  @pragma('vm:prefer-inline')
  Widget wideBody(BuildContext context) {
    return body(context);
  }

  /// The main content of the screen — must be implemented by subclasses.
  Widget body(BuildContext context);

  /// Override to specify the alignment of the [body] within the layout. The
  /// default places the body at the top, padded by [sideInsets].
  ///
  /// Mix in one of the alignment mixins ([DefaultScrollableAlignScreenMixin],
  /// [NeverScrollableAlignScreenMixin], [DefaultNoScrollableAlignScreenMixin])
  /// for richer behavior, or override this method directly.
  @pragma('vm:prefer-inline')
  Widget align(BuildContext context, Widget body, EdgeInsets sideInsets) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(padding: sideInsets, child: body),
    );
  }

  /// Override to specify the padding for the body. Defaults to no padding so
  /// users can compose their own design system on top.
  @pragma('vm:prefer-inline')
  Widget padding(BuildContext context, Widget child) {
    return Padding(padding: EdgeInsets.zero, child: child);
  }

  /// Override to further define how the main [body], [background] and
  /// [foreground] are presented.
  ///
  /// Tip: This is useful for showing or hiding the body content from the
  /// user or displaying loading indicators while the body content is being
  /// loaded.
  @pragma('vm:prefer-inline')
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
        Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: body,
        ),
        foreground,
      ],
    );
  }

  /// Override to specify the side insets for the body. Side insets are
  /// applied to the top, bottom, left, and right of the body. They are
  /// added to the [padding].
  ///
  /// The [preferredInsets] are determined from [topSide],
  /// [bottomSide], [leftSide], and [rightSide].
  @pragma('vm:prefer-inline')
  EdgeInsets sideInsets(EdgeInsets preferredInsets) {
    return preferredInsets;
  }

  /// Override to specify the background. This is rendered behind the body.
  @pragma('vm:prefer-inline')
  Widget background(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: const SizedBox.expand(),
    );
  }

  /// Override to specify the foreground. This is rendered over the body.
  ///
  /// Tip: Use an [IgnorePointer] when creating non-interactive overlays.
  @pragma('vm:prefer-inline')
  Widget foreground(BuildContext context) {
    return const IgnorePointer(child: SizedBox.expand());
  }

  /// Override to customize the top area of your screen.
  ///
  /// Tip: Ideal for placing elements like headers.
  @pragma('vm:prefer-inline')
  Widget topSide(BuildContext context, double topInsets) {
    return const SizedBox.shrink();
  }

  /// Override to customize the bottom area of your screen.
  ///
  /// Tip: Ideal for placing elements like navigation controls.
  @pragma('vm:prefer-inline')
  Widget bottomSide(BuildContext context, double bottomInsets) {
    return const SizedBox.shrink();
  }

  /// Override to customize the left area of your screen.
  ///
  /// Tip: Ideal for placing elements like menus and side panels.
  @pragma('vm:prefer-inline')
  Widget leftSide(BuildContext context, double leftInsets) {
    return const SizedBox.shrink();
  }

  /// Override to customize the right area of your screen.
  ///
  /// Tip: Ideal for placing elements like menus and side panels.
  @pragma('vm:prefer-inline')
  Widget rightSide(BuildContext context, double rightInsets) {
    return const SizedBox.shrink();
  }

  /// Configures how the top side behaves.
  @pragma('vm:prefer-inline')
  AdaptiveScreenSideMode get topSideMode => AdaptiveScreenSideMode.STATIC;

  /// Configures how the bottom side behaves.
  @pragma('vm:prefer-inline')
  AdaptiveScreenSideMode get bottomSideMode => AdaptiveScreenSideMode.STATIC;

  /// Configures how the left side behaves.
  @pragma('vm:prefer-inline')
  AdaptiveScreenSideMode get leftSideMode => AdaptiveScreenSideMode.STATIC;

  /// Configures how the right side behaves.
  @pragma('vm:prefer-inline')
  AdaptiveScreenSideMode get rightSideMode => AdaptiveScreenSideMode.STATIC;

  /// Plug in a custom layout resolver. Returning `null` falls back to the
  /// default [AppLayout.fromSize] classification. Useful for embedding the
  /// screen in a constrained sub-window or for non-standard form factors.
  @pragma('vm:prefer-inline')
  LayoutResolver? get layoutResolver => null;

  /// Optional override of the [LayoutBreakpoints] used for adaptive layout
  /// detection on this screen. Defaults to [LayoutBreakpoints.global].
  @pragma('vm:prefer-inline')
  LayoutBreakpoints? get layoutBreakpoints => null;

  /// Minimum sizes for each side. Used to reserve space when a side is in
  /// [AdaptiveScreenSideMode.OVERLAY_WITH_PADDING] before it has been measured.
  @pragma('vm:prefer-inline')
  double get minTopSideSize => kToolbarHeight;
  @pragma('vm:prefer-inline')
  double get minBottomSideSize => 0.0;
  @pragma('vm:prefer-inline')
  double get minLeftSideSize => 0.0;
  @pragma('vm:prefer-inline')
  double get minRightSideSize => 0.0;
}
