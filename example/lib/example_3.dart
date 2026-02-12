import 'package:df_screen/df_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(child: OverlayExampleScreen()),
    ),
  );
}

/// 1. THE SCREEN
base class OverlayExampleScreen extends Screen {
  const OverlayExampleScreen({super.key});

  @override
  State createState() => _OverlayExampleScreenState();

  @override
  ScreenController createController(Screen screen, ScreenState state) {
    return OverlayExampleController(screen, state);
  }
}

/// 2. THE CONTROLLER (Business Logic)
final class OverlayExampleController extends ScreenController {
  OverlayExampleController(super.screen, super.state);

  void onActionPressed() {
    print("Action button tapped!");
  }
}

/// 3. THE STATE (UI & Adaptive Layout)
final class _OverlayExampleScreenState extends AdaptiveScreenState<
    OverlayExampleScreen, OverlayExampleController> {
  // Use OVERLAY so the body content scrolls behind the header/footer
  @override
  AdaptiveScreenSideMode get topSideMode => AdaptiveScreenSideMode.OVERLAY;

  @override
  AdaptiveScreenSideMode get bottomSideMode => AdaptiveScreenSideMode.OVERLAY;

  // By setting these, the framework avoids "layout jumps" on the first frame
  @override
  double get minTopSideSize => 80.0;
  @override
  double get minBottomSideSize => 90.0;

  /// THE HEADER (TopSide)
  @override
  Widget topSide(BuildContext context, double topInsets) {
    return PreferredSize(
      preferredSize: Size.fromHeight(minTopSideSize + topInsets),
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // Glassmorphism effect
          color: Colors.white.withAlpha(200),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: ListTile(
            leading: const CircleAvatar(
                backgroundColor: Colors.indigo,
                child: Icon(Icons.person, color: Colors.white)),
            title: const Text('Hello, Explorer',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Welcome back!'),
            trailing: IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: c.onActionPressed,
            ),
          ),
        ),
      ),
    );
  }

  /// THE NAVIGATION BAR (BottomSide)
  @override
  Widget bottomSide(BuildContext context, double bottomInsets) {
    return PreferredSize(
      preferredSize: Size.fromHeight(minBottomSideSize + bottomInsets),
      child: Container(
        padding: EdgeInsets.only(
            bottom: bottomInsets + 10, left: 20, right: 20, top: 10),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.indigo.shade900,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 20)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navIcon(Icons.home, true),
              _navIcon(Icons.search, false),
              _navIcon(Icons.favorite_border, false),
              _navIcon(Icons.settings, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, bool active) {
    return Icon(icon, color: active ? Colors.white : Colors.white54, size: 28);
  }

  /// THE MAIN CONTENT
  @override
  Widget body(BuildContext context) {
    return ListView.builder(
      // CRITICAL: Use the built-in controller for synchronized animations
      controller: bodyScrollController,
      // Add padding so the first/last items aren't hidden under the overlays
      padding: EdgeInsets.only(
        top: minTopSideSize + 30,
        bottom: minBottomSideSize + 20,
        left: 16,
        right: 16,
      ),
      itemCount: 25,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.indigo.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                      child: Text('#$index',
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Adaptive Overlay Card',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Scroll behind the floating bars...',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // Set the background color for the whole screen
  @override
  Widget background(BuildContext context) {
    return Container(color: Colors.grey.shade100);
  }
}
