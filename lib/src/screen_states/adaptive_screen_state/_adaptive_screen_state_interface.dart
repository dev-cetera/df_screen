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

import 'package:flutter/material.dart';

import '/src/_src.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract base class AdaptiveScreenStateInterface<TScreen extends Screen, TController extends ScreenController>
    extends ScreenState<TScreen, TController> {
  /// Activates for mobile device screen sizes. Override to customize the
  /// layout for these sizes. The [body] includes the widget returned by
  /// [mobileBody].
  @pragma('vm:prefer-inline')
  Widget mobileLayout(BuildContext context, Widget body) {
    return narrowLayout(context, body);
  }

  /// Activates for mobile device screen sizes ith a horizontal orientation.
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

  /// Activates for mobile device screen sizes. Override to customize the  body
  /// for these sizes.
  @pragma('vm:prefer-inline')
  Widget mobileBody(BuildContext context) {
    return narrowBody(context);
  }

  /// Activates for mobile device screen sizes ith a horizontal orientation.
  /// Override to customize the  body for these sizes.
  @pragma('vm:prefer-inline')
  Widget horizontalMobileBody(BuildContext context) {
    return wideBody(context);
  }

  /// Activates for non-mobile narrow screen sizes, such as a narrow desktop
  /// window or screen. Override to customize the  body for these sizes.
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

  /// Activates for screen sizes that do not match the criteria for
  /// [mobileLayout], [horizontalMobileLayout], [narrowLayout], or [wideLayout].
  /// Override to customize the body for these sizes.
  Widget body(BuildContext context);

  /// Override to specify the alignment of the [body] within the layout. Ideal
  /// for implementing scroll views. The [sideInsets] are set to correspond
  /// with the dimensions of widgets returned by [topSide], [bottomSide],
  /// [leftSide], and [rightSide].
  Widget align(BuildContext context, Widget body, EdgeInsets sideInsets);

  /// Override to specify the padding for the body.
  Widget padding(Widget child);

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
  ///     pod: _pIsLoading,
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
        // GestureDetector(
        //   onTap: () => FocusScope.of(context).unfocus(),
        //   child: background,
        // ),
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
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: const SizedBox.expand(),
      ),
    );
  }

  /// Override to specify the foregound. This is rendered over the body.
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

  //// Override to customize the left area of your screen.
  ///
  /// Tip: Ideal for placing elements like menus and side panels.
  @pragma('vm:prefer-inline')
  Widget leftSide(BuildContext context, double leftInsets) {
    return const SizedBox.shrink();
  }

  //// Override to customize the right area of your screen.
  ///
  /// Tip: Ideal for placing elements like menus and side panels.
  @pragma('vm:prefer-inline')
  Widget rightSide(BuildContext context, double rightInsets) {
    return const SizedBox.shrink();
  }
}
