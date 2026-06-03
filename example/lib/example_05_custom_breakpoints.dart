// Two ways to retune adaptive layout:
//   1. Set LayoutBreakpoints.global before runApp() to retune every screen.
//   2. Override `layoutBreakpoints` and/or `layoutResolver` on a single
//      screen for hyper-local tweaks.

import 'package:df_screen/df_screen.dart';
import 'package:flutter/material.dart';

void main() {
  // Globally: anything narrower than 720px is considered "mobile-sized".
  LayoutBreakpoints.global = const LayoutBreakpoints(
    mobileMaxShortestSide: 720,
  );
  runApp(const MaterialApp(home: TunedScreen()));
}

base class TunedScreen extends Screen {
  const TunedScreen({super.key});
  @override
  State createState() => _State();
}

base class _State extends AdaptiveScreenState<TunedScreen, ScreenController> {
  // Per-screen override: this screen treats anything narrower than 1000px
  // as NARROW, regardless of platform.
  @override
  LayoutResolver get layoutResolver => (context, size) {
        if (size.width >= 1200) return AppLayout.WIDE;
        if (size.width >= 1000) return AppLayout.NARROW;
        return AppLayout.MOBILE;
      };

  @override
  Widget body(BuildContext context) {
    // Show what the resolver picked.
    final layout = AppLayout.of(context);
    return Center(
      child: Text(
        'Current layout (default resolver): $layout',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  @override
  Widget wideBody(BuildContext context) {
    return _layoutLabel(context, 'WIDE — three-column desktop UI here');
  }

  @override
  Widget narrowBody(BuildContext context) {
    return _layoutLabel(context, 'NARROW — two-column tablet UI here');
  }

  @override
  Widget mobileBody(BuildContext context) {
    return _layoutLabel(context, 'MOBILE — single column UI here');
  }

  Widget _layoutLabel(BuildContext context, String text) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(48),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
