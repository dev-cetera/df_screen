// Showcases the four AdaptiveScreenSideMode values side by side. Tap the
// chips at the top to switch modes; observe how the top side behaves:
//
//   - STATIC: fixed in the layout, body lives below it.
//   - OVERLAY: stacked above the body, body extends behind it.
//   - OVERLAY_WITH_PADDING: like OVERLAY, but the body is padded so it
//     doesn't render *under* the side.
//   - SLIVER: scrolls with the body — collapses as the body scrolls down.

import 'package:df_screen/df_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: SideModeShowcase()));
}

class SideModeShowcase extends StatefulWidget {
  const SideModeShowcase({super.key});
  @override
  State<SideModeShowcase> createState() => _SideModeShowcaseState();
}

class _SideModeShowcaseState extends State<SideModeShowcase> {
  AdaptiveScreenSideMode _mode = AdaptiveScreenSideMode.STATIC;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Wrap(
              spacing: 8,
              children: [
                for (final mode in AdaptiveScreenSideMode.values)
                  ChoiceChip(
                    label: Text(mode.name),
                    selected: _mode == mode,
                    onSelected: (_) => setState(() => _mode = mode),
                  ),
              ],
            ),
          ),
        ),
        Expanded(child: _DemoScreen(mode: _mode, key: ValueKey(_mode))),
      ],
    );
  }
}

base class _DemoScreen extends Screen {
  const _DemoScreen({super.key, required this.mode});
  final AdaptiveScreenSideMode mode;

  @override
  State createState() => _DemoScreenState();
}

base class _DemoScreenState
    extends AdaptiveScreenState<_DemoScreen, ScreenController> {
  @override
  AdaptiveScreenSideMode get topSideMode => widget.mode;

  @override
  double get minTopSideSize => 60;

  @override
  PreferredSizeWidget topSide(BuildContext context, double topInsets) {
    return PreferredSize(
      preferredSize: Size.fromHeight(120 + topInsets),
      child: Container(
        color: Colors.indigo.shade400,
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.only(left: 16, bottom: 12, top: topInsets),
        child: Text(
          'Mode: ${widget.mode.name}',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return ListView.builder(
      controller: bodyScrollController,
      itemCount: 30,
      itemBuilder: (context, i) => ListTile(
        leading: CircleAvatar(child: Text('$i')),
        title: Text('Item $i'),
        subtitle: const Text('Scroll me to see SLIVER behavior'),
      ),
    );
  }
}
