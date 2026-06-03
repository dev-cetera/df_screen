// DefaultAdaptiveScreenState gives you the opinionated set of mixins out of
// the box:
//   - DefaultScrollableAlignScreenMixin (bouncing scroll, dismiss-on-drag)
//   - DefaultPaddingScreenMixin (28.sc top/sides, 112.sc bottom)
//   - MobileFrameWideLayoutScreenMixin (mobile-shaped frame on desktop)
//   - RotateIconHorizontalMobileLayoutScreenMixin (asks the user to rotate)
//
// You override the same hooks as on AdaptiveScreenState; the mixins just
// supply richer defaults so you can implement `body()` and ship.

import 'package:df_screen/df_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: OpinionatedScreen()));
}

base class OpinionatedScreen extends Screen {
  const OpinionatedScreen({super.key});

  @override
  State createState() => _State();
}

base class _State extends DefaultAdaptiveScreenState<OpinionatedScreen, ScreenController> {
  // Replace the default 28.sc / 112.sc padding without forking the mixin.
  @override
  EdgeInsets get defaultPaddingInsets => const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      );

  @override
  Widget body(BuildContext context) {
    // List long enough that the scrollable-align mixin shows real motion.
    return ListView.builder(
      controller: bodyScrollController,
      itemCount: 30,
      itemBuilder: (context, i) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Text('$i')),
            title: Text('Opinionated item $i'),
            subtitle: const Text('Scrolls inside the default scrollable mixin.'),
          ),
        );
      },
    );
  }

  @override
  PreferredSizeWidget topSide(BuildContext context, double topInsets) {
    return PreferredSize(
      preferredSize: Size.fromHeight(56 + topInsets),
      child: AppBar(
        title: const Text('DefaultAdaptiveScreenState'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
