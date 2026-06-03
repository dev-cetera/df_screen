//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Copyright © dev-cetera.com & contributors.
// MIT license. See https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:df_screen/df_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps a widget so AdaptiveScreenState / RouteWidgetMixin internals have
/// the Theme / Directionality / Material they expect, while leaving
/// MediaQuery directly controllable by the test.
Widget wrapApp(Widget child, {Size? size}) {
  return MediaQuery(
    data: MediaQueryData(size: size ?? const Size(400, 800)),
    child: Theme(
      data: ThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(child: child),
      ),
    ),
  );
}

/// Pumps a widget tree at a given logical screen size. Returns when the
/// first frame settles.
Future<void> pumpAtSize(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(400, 800),
}) async {
  await tester.pumpWidget(wrapApp(child, size: size));
  await tester.pump();
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A minimal Screen + ScreenState + ScreenController triplet used across
/// tests. Counts lifecycle calls and surfaces the latest controller.
final class TestScreen extends Screen {
  const TestScreen({
    super.key,
    super.routeState,
    super.controllerTimeout,
    this.bodyText = 'body',
    this.onBuildController,
  });

  final String bodyText;
  final void Function(TestController)? onBuildController;

  @override
  TestScreenState createState() => TestScreenState();

  @override
  ScreenController createController(Screen screen, ScreenState state) {
    final c = TestController(screen, state);
    onBuildController?.call(c);
    return c;
  }
}

base class TestScreenState extends ScreenState<TestScreen, TestController> {
  static var buildCount = 0;
  static var disposeCount = 0;
  static var initCount = 0;

  static void reset() {
    buildCount = 0;
    disposeCount = 0;
    initCount = 0;
    TestController.reset();
  }

  @override
  void initState() {
    initCount++;
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    buildCount++;
    return Center(
      child: Text(
        widget.bodyText,
        textDirection: TextDirection.ltr,
      ),
    );
  }

  @override
  void dispose() {
    disposeCount++;
    super.dispose();
  }
}

base class TestController extends ScreenController {
  TestController(super.superScreen, super.superState);

  static var instances = 0;
  static var initCount = 0;
  static var disposeCount = 0;
  static Object? thrownByInit;
  static Duration? initDelay;

  static void reset() {
    instances = 0;
    initCount = 0;
    disposeCount = 0;
    thrownByInit = null;
    initDelay = null;
  }

  @override
  Future<void> initController() async {
    await super.initController();
    instances++;
    if (initDelay != null) {
      await Future<void>.delayed(initDelay!);
    }
    initCount++;
    if (thrownByInit != null) {
      throw thrownByInit!;
    }
  }

  @override
  void dispose() {
    disposeCount++;
    super.dispose();
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A bare AdaptiveScreenState screen for layout tests.
final class AdaptiveTestScreen extends Screen {
  const AdaptiveTestScreen({
    super.key,
    super.routeState,
    super.controllerTimeout,
    this.topMode = AdaptiveScreenSideMode.STATIC,
    this.bottomMode = AdaptiveScreenSideMode.STATIC,
    this.leftMode = AdaptiveScreenSideMode.STATIC,
    this.rightMode = AdaptiveScreenSideMode.STATIC,
    this.minTopSize = kToolbarHeight,
    this.showTopSide = false,
    this.showBottomSide = false,
    this.showLeftSide = false,
    this.showRightSide = false,
    this.bodyKey,
    this.layoutResolver,
    this.breakpoints,
  });

  final AdaptiveScreenSideMode topMode;
  final AdaptiveScreenSideMode bottomMode;
  final AdaptiveScreenSideMode leftMode;
  final AdaptiveScreenSideMode rightMode;
  final double minTopSize;
  final bool showTopSide;
  final bool showBottomSide;
  final bool showLeftSide;
  final bool showRightSide;
  final Key? bodyKey;
  final LayoutResolver? layoutResolver;
  final LayoutBreakpoints? breakpoints;

  @override
  AdaptiveTestScreenState createState() => AdaptiveTestScreenState();
}

base class AdaptiveTestScreenState
    extends AdaptiveScreenState<AdaptiveTestScreen, ScreenController> {
  static var bodyBuildCount = 0;
  static AppLayout? lastLayout;

  static void reset() {
    bodyBuildCount = 0;
    lastLayout = null;
  }

  @override
  LayoutResolver? get layoutResolver => widget.layoutResolver;

  @override
  LayoutBreakpoints? get layoutBreakpoints => widget.breakpoints;

  @override
  AdaptiveScreenSideMode get topSideMode => widget.topMode;

  @override
  AdaptiveScreenSideMode get bottomSideMode => widget.bottomMode;

  @override
  AdaptiveScreenSideMode get leftSideMode => widget.leftMode;

  @override
  AdaptiveScreenSideMode get rightSideMode => widget.rightMode;

  @override
  double get minTopSideSize => widget.minTopSize;

  @override
  Widget body(BuildContext context) {
    bodyBuildCount++;
    return KeyedSubtree(
      key: widget.bodyKey,
      child: const SizedBox.expand(),
    );
  }

  // The body-routing hooks below record which one the build pipeline
  // actually selected, which is the test signal for AppLayout selection.
  @override
  Widget mobileBody(BuildContext context) {
    lastLayout = AppLayout.MOBILE;
    return body(context);
  }

  @override
  Widget horizontalMobileBody(BuildContext context) {
    lastLayout = AppLayout.MOBILE_HORIZONTAL;
    return body(context);
  }

  @override
  Widget narrowBody(BuildContext context) {
    lastLayout = AppLayout.NARROW;
    return body(context);
  }

  @override
  Widget wideBody(BuildContext context) {
    lastLayout = AppLayout.WIDE;
    return body(context);
  }

  @override
  Widget topSide(BuildContext context, double topInsets) {
    if (!widget.showTopSide) return const SizedBox.shrink();
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Container(
        color: const Color(0xFFFF0000),
        key: const Key('topSide'),
      ),
    );
  }

  @override
  Widget bottomSide(BuildContext context, double bottomInsets) {
    if (!widget.showBottomSide) return const SizedBox.shrink();
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Container(
        color: const Color(0xFF00FF00),
        key: const Key('bottomSide'),
      ),
    );
  }

  @override
  Widget leftSide(BuildContext context, double leftInsets) {
    if (!widget.showLeftSide) return const SizedBox.shrink();
    return PreferredSize(
      preferredSize: const Size.fromWidth(48),
      child: Container(
        color: const Color(0xFF0000FF),
        key: const Key('leftSide'),
      ),
    );
  }

  @override
  Widget rightSide(BuildContext context, double rightInsets) {
    if (!widget.showRightSide) return const SizedBox.shrink();
    return PreferredSize(
      preferredSize: const Size.fromWidth(48),
      child: Container(
        color: const Color(0xFFFFFF00),
        key: const Key('rightSide'),
      ),
    );
  }
}
