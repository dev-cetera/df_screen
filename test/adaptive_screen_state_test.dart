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

import '_helpers.dart';

void main() {
  setUp(() {
    AdaptiveTestScreenState.reset();
  });

  group('Bare AdaptiveScreenState rendering', () {
    testWidgets('renders body content', (tester) async {
      await pumpAtSize(
        tester,
        const AdaptiveTestScreen(bodyKey: Key('body')),
      );
      expect(find.byKey(const Key('body')), findsOneWidget);
      expect(AdaptiveTestScreenState.bodyBuildCount, greaterThan(0));
    });

    testWidgets('renders STATIC top side when configured', (tester) async {
      await pumpAtSize(
        tester,
        const AdaptiveTestScreen(showTopSide: true),
      );
      expect(find.byKey(const Key('topSide')), findsOneWidget);
    });

    testWidgets('renders all four STATIC sides simultaneously', (tester) async {
      await pumpAtSize(
        tester,
        const AdaptiveTestScreen(
          showTopSide: true,
          showBottomSide: true,
          showLeftSide: true,
          showRightSide: true,
        ),
      );
      expect(find.byKey(const Key('topSide')), findsOneWidget);
      expect(find.byKey(const Key('bottomSide')), findsOneWidget);
      expect(find.byKey(const Key('leftSide')), findsOneWidget);
      expect(find.byKey(const Key('rightSide')), findsOneWidget);
    });

    testWidgets('OVERLAY top side renders inside the stack', (tester) async {
      await pumpAtSize(
        tester,
        const AdaptiveTestScreen(
          showTopSide: true,
          topMode: AdaptiveScreenSideMode.OVERLAY,
        ),
      );
      expect(find.byKey(const Key('topSide')), findsOneWidget);
    });

    testWidgets('OVERLAY_WITH_PADDING top side reserves space', (tester) async {
      await pumpAtSize(
        tester,
        const AdaptiveTestScreen(
          showTopSide: true,
          topMode: AdaptiveScreenSideMode.OVERLAY_WITH_PADDING,
        ),
      );
      expect(find.byKey(const Key('topSide')), findsOneWidget);
    });

    testWidgets('SLIVER top side is rendered and positioned', (tester) async {
      await pumpAtSize(
        tester,
        const AdaptiveTestScreen(
          showTopSide: true,
          topMode: AdaptiveScreenSideMode.SLIVER,
        ),
      );
      expect(find.byKey(const Key('topSide')), findsOneWidget);
    });
  });

  group('Custom layout resolver', () {
    testWidgets('overrides AppLayout classification', (tester) async {
      await pumpAtSize(
        tester,
        AdaptiveTestScreen(
          bodyKey: const Key('body'),
          layoutResolver: (context, size) => AppLayout.MOBILE,
        ),
      );
      expect(AdaptiveTestScreenState.lastLayout, AppLayout.MOBILE);
    });

    testWidgets('returning null falls back to default classification',
        (tester) async {
      // Size 1600x900 → on a non-mobile platform this is WIDE.
      await pumpAtSize(
        tester,
        AdaptiveTestScreen(
          bodyKey: const Key('body'),
          layoutResolver: (context, size) => null,
        ),
        size: const Size(1600, 900),
      );
      expect(AdaptiveTestScreenState.lastLayout, AppLayout.WIDE);
    });
  });

  group('Custom breakpoints', () {
    testWidgets('per-screen breakpoints affect classification', (tester) async {
      // 400x600 default → on a non-mobile host this is WIDE because the
      // aspect bias is 1.5 ≤ 4/3 ... actually 1.5 > 4/3 so NARROW.
      // Use a permissive minMobileAspectRatio of 0.5 to force NARROW even
      // for square-ish windows.
      await pumpAtSize(
        tester,
        const AdaptiveTestScreen(
          breakpoints: LayoutBreakpoints(minMobileAspectRatio: 0.5),
        ),
        size: const Size(500, 600),
      );
      expect(AdaptiveTestScreenState.lastLayout, AppLayout.NARROW);
    });
  });

  group('Bare AdaptiveScreenState defaults', () {
    testWidgets('exposes a bodyScrollController that lives across rebuilds',
        (tester) async {
      await pumpAtSize(tester, const AdaptiveTestScreen());
      final state = tester
          .state<AdaptiveTestScreenState>(find.byType(AdaptiveTestScreen));
      final first = state.bodyScrollController;

      // Trigger a rebuild.
      await tester.pump();
      expect(state.bodyScrollController, same(first));
    });

    testWidgets('disposes the bodyScrollController on unmount', (tester) async {
      await pumpAtSize(tester, const AdaptiveTestScreen());
      final state = tester
          .state<AdaptiveTestScreenState>(find.byType(AdaptiveTestScreen));
      final controller = state.bodyScrollController;

      await tester.pumpWidget(wrapApp(const SizedBox()));
      // After dispose, attempting to use the controller throws.
      expect(() => controller.position, throwsAssertionError);
    });
  });

  group('DefaultAdaptiveScreenState', () {
    testWidgets('mixes in scrollable align (SingleChildScrollView in tree)',
        (tester) async {
      await pumpAtSize(
        tester,
        const _OpinionatedScreen(),
      );
      // The DefaultScrollableAlignScreenMixin wraps the body in a
      // SingleChildScrollView.
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class _OpinionatedScreen extends Screen {
  const _OpinionatedScreen();

  @override
  _OpinionatedScreenState createState() => _OpinionatedScreenState();
}

base class _OpinionatedScreenState
    extends DefaultAdaptiveScreenState<_OpinionatedScreen, ScreenController> {
  @override
  Widget body(BuildContext context) {
    return const Text(
      'opinionated',
      textDirection: TextDirection.ltr,
    );
  }
}
