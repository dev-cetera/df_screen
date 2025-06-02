import 'package:flutter/material.dart';

import '_src.g.dart';
import 'package:df_type/df_type.dart' show letAsOrNull;

/// A widget that adapts its layout based on screen size and orientation using AppLayout.
/// Supports WIDE, NARROW, MOBILE_HORIZONTAL, and MOBILE layouts, compatible with AdaptiveScreenStateInterface.
class AdaptiveLayoutBuilder extends StatelessWidget {
  /// Builder for the main content body
  final Widget Function(BuildContext) bodyBuilder;

  /// Optional builders for specific layouts
  final Widget Function(BuildContext, Widget)? mobileLayoutBuilder;
  final Widget Function(BuildContext, Widget)? horizontalMobileLayoutBuilder;
  final Widget Function(BuildContext, Widget)? narrowLayoutBuilder;
  final Widget Function(BuildContext, Widget)? wideLayoutBuilder;

  /// Optional builders for specific body content
  final Widget Function(BuildContext)? mobileBodyBuilder;
  final Widget Function(BuildContext)? horizontalMobileBodyBuilder;
  final Widget Function(BuildContext)? narrowBodyBuilder;
  final Widget Function(BuildContext)? wideBodyBuilder;

  /// Optional side widgets
  final Widget Function(BuildContext, double)? topSideBuilder;
  final Widget Function(BuildContext, double)? bottomSideBuilder;
  final Widget Function(BuildContext, double)? leftSideBuilder;
  final Widget Function(BuildContext, double)? rightSideBuilder;

  /// Optional background and foreground
  final Widget Function(BuildContext)? backgroundBuilder;
  final Widget Function(BuildContext)? foregroundBuilder;

  /// Padding for the body
  final Widget Function(BuildContext, Widget)? paddingBuilder;

  /// Alignment for the body with side insets
  final Widget Function(BuildContext, Widget, EdgeInsets)? alignBuilder;

  /// Presentation of body, background, and foreground
  final Widget Function(BuildContext, Widget, Widget, Widget)? presentationBuilder;

  /// Side insets calculation
  final EdgeInsets Function(BuildContext, EdgeInsets)? sideInsetsBuilder;

  const AdaptiveLayoutBuilder({
    super.key,
    required this.bodyBuilder,
    this.mobileLayoutBuilder,
    this.horizontalMobileLayoutBuilder,
    this.narrowLayoutBuilder,
    this.wideLayoutBuilder,
    this.mobileBodyBuilder,
    this.horizontalMobileBodyBuilder,
    this.narrowBodyBuilder,
    this.wideBodyBuilder,
    this.topSideBuilder,
    this.bottomSideBuilder,
    this.leftSideBuilder,
    this.rightSideBuilder,
    this.backgroundBuilder,
    this.foregroundBuilder,
    this.paddingBuilder,
    this.alignBuilder,
    this.presentationBuilder,
    this.sideInsetsBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layoutType = AppLayout.currentScreenLayout();

        // Build the appropriate body based on layout type
        var body = _buildBody(context, layoutType);

        // Apply padding
        body = paddingBuilder?.call(context, body) ?? body;

        // Build side widgets
        final topSide = topSideBuilder?.call(context, MediaQuery.of(context).viewInsets.top) ??
            const SizedBox.shrink();
        final bottomSide =
            bottomSideBuilder?.call(context, MediaQuery.of(context).viewInsets.bottom) ??
                const SizedBox.shrink();
        final leftSide = leftSideBuilder?.call(context, MediaQuery.of(context).viewInsets.left) ??
            const SizedBox.shrink();
        final rightSide =
            rightSideBuilder?.call(context, MediaQuery.of(context).viewInsets.right) ??
                const SizedBox.shrink();

        // Calculate side insets
        final sideInsets = sideInsetsBuilder?.call(
              context,
              EdgeInsets.only(
                left: letAsOrNull<PreferredSizeWidget>(leftSide)?.preferredSize.width ?? 0.0,
                right: letAsOrNull<PreferredSizeWidget>(rightSide)?.preferredSize.width ?? 0.0,
                top: letAsOrNull<PreferredSizeWidget>(topSide)?.preferredSize.height ?? 0.0,
                bottom: letAsOrNull<PreferredSizeWidget>(bottomSide)?.preferredSize.height ?? 0.0,
              ),
            ) ??
            EdgeInsets.zero;

        // Align body with side insets
        body = alignBuilder?.call(context, body, sideInsets) ??
            _defaultAlign(context, body, sideInsets);

        // Combine body with side widgets
        body = Stack(
          alignment: AlignmentDirectional.center,
          fit: StackFit.expand,
          children: [
            body,
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
                              constraints: BoxConstraints.loose(leftSide.preferredSize),
                              child: leftSide,
                            )
                          : leftSide,
                      const Spacer(),
                      rightSide is PreferredSizeWidget
                          ? ConstrainedBox(
                              constraints: BoxConstraints.loose(rightSide.preferredSize),
                              child: rightSide,
                            )
                          : rightSide,
                    ],
                  ),
                ),
                bottomSide is PreferredSizeWidget
                    ? ConstrainedBox(
                        constraints: BoxConstraints.loose(bottomSide.preferredSize),
                        child: bottomSide,
                      )
                    : bottomSide,
              ],
            ),
          ],
        );

        // Apply presentation
        body = presentationBuilder?.call(
              context,
              body,
              backgroundBuilder?.call(context) ?? _defaultBackground(context),
              foregroundBuilder?.call(context) ?? _defaultForeground(context),
            ) ??
            _defaultPresentation(
              context,
              body,
              backgroundBuilder?.call(context) ?? _defaultBackground(context),
              foregroundBuilder?.call(context) ?? _defaultForeground(context),
            );

        // Apply layout
        body = _buildLayout(context, body, layoutType);

        return ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: body,
        );
      },
    );
  }

  /// Builds the body based on layout type
  Widget _buildBody(BuildContext context, AppLayout layoutType) {
    switch (layoutType) {
      case AppLayout.MOBILE:
        return mobileBodyBuilder?.call(context) ??
            narrowBodyBuilder?.call(context) ??
            bodyBuilder(context);
      case AppLayout.MOBILE_HORIZONTAL:
        return horizontalMobileBodyBuilder?.call(context) ??
            wideBodyBuilder?.call(context) ??
            bodyBuilder(context);
      case AppLayout.NARROW:
        return narrowBodyBuilder?.call(context) ?? bodyBuilder(context);
      case AppLayout.WIDE:
        return wideBodyBuilder?.call(context) ?? bodyBuilder(context);
    }
  }

  /// Builds the layout based on layout type
  Widget _buildLayout(BuildContext context, Widget body, AppLayout layoutType) {
    switch (layoutType) {
      case AppLayout.MOBILE:
        return mobileLayoutBuilder?.call(context, body) ??
            narrowLayoutBuilder?.call(context, body) ??
            body;
      case AppLayout.MOBILE_HORIZONTAL:
        return horizontalMobileLayoutBuilder?.call(context, body) ??
            wideLayoutBuilder?.call(context, body) ??
            body;
      case AppLayout.NARROW:
        return narrowLayoutBuilder?.call(context, body) ?? body;
      case AppLayout.WIDE:
        return wideLayoutBuilder?.call(context, body) ?? body;
    }
  }
}

/// Default alignment
Widget _defaultAlign(BuildContext context, Widget body, EdgeInsets sideInsets) {
  return Padding(
    padding: sideInsets + MediaQuery.of(context).padding,
    child: body,
  );
}

/// Default presentation
Widget _defaultPresentation(
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

/// Default background
Widget _defaultBackground(BuildContext context) {
  return ColoredBox(
    color: Theme.of(context).colorScheme.surface,
    child: GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: const SizedBox.expand(),
    ),
  );
}

/// Default foreground
Widget _defaultForeground(BuildContext context) {
  return const IgnorePointer(child: SizedBox.expand());
}
