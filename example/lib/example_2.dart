import 'package:df_screen/df_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adaptive Screen Example',
      home: ExampleScreen(),
    );
  }
}

base class ExampleScreen extends Screen {
  const ExampleScreen({super.key});

  @override
  State createState() => ExampleScreenState();

  @override
  ScreenController createController(Screen screen, ScreenState state) {
    return ExampleScreenController(screen, state);
  }
}

final class ExampleScreenController extends ScreenController {
  ExampleScreenController(super.screen, super.state);
}

final class ExampleScreenState
    extends AdaptiveScreenState<ExampleScreen, ExampleScreenController> {
  @override
  AdaptiveScreenSideMode get topSideMode => AdaptiveScreenSideMode.SLIVER;

  @override
  AdaptiveScreenSideMode get leftSideMode =>
      AdaptiveScreenSideMode.OVERLAY_WITH_PADDING;

  @override
  AdaptiveScreenSideMode get rightSideMode => AdaptiveScreenSideMode.OVERLAY;

  @override
  AdaptiveScreenSideMode get bottomSideMode => AdaptiveScreenSideMode.STATIC;

  @override
  double get minTopSideSize => 80.0;

  @override
  Widget topSide(BuildContext context, double topInsets) {
    return AdaptiveScrollBuilder(
      controller: bodyScrollController,
      expandedSize: 250.0,
      collapsedSize: minTopSideSize,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade800, Colors.teal.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 10.0),
          ],
        ),
        child: const Center(
          child: Opacity(
            opacity: 0.3,
            child: Icon(Icons.waves, size: 300.0, color: Colors.white),
          ),
        ),
      ),
      builder: (context, percentage, staticChild) {
        return SizedBox(
          height: 250.0,
          child: Stack(
            children: [
              Positioned.fill(child: staticChild!),
              Positioned(
                bottom: 20.0 + (20.0 * (1.0 - percentage)),
                left: 20.0,
                child: Opacity(
                  opacity: percentage,
                  child: const Text(
                    'Large Expanded Title',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40.0,
                left: 0.0,
                right: 0.0,
                child: Opacity(
                  opacity: (1.0 - percentage),
                  child: const Center(
                    child: Text(
                      'My App',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget leftSide(BuildContext context, double leftInsets) {
    return AdaptiveScrollBuilder(
      controller: bodyScrollController,
      expandedSize: 300.0,
      collapsedSize: 0.0,
      builder: (context, percentage, _) {
        return Container(
          width: 70.0,
          decoration: BoxDecoration(
            color: Color.lerp(
              Colors.white.withAlpha(200),
              Colors.teal.shade50.withAlpha(240),
              1.0 - percentage,
            ),
            border: Border(right: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: 0.8 + (0.4 * percentage),
                child: const Icon(Icons.dashboard, color: Colors.teal),
              ),
              const SizedBox(height: 20.0),
              const Icon(Icons.person, color: Colors.grey),
              const SizedBox(height: 20.0),
              Opacity(
                opacity: percentage,
                child: const Icon(Icons.settings, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget rightSide(BuildContext context, double rightInsets) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(right: 10.0),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: const Icon(Icons.arrow_upward, color: Colors.white),
      ),
    );
  }

  @override
  Widget bottomSide(BuildContext context, double bottomInsets) {
    return Container(
      height: 60.0 + bottomInsets,
      color: Colors.white,
      padding: EdgeInsets.only(bottom: bottomInsets),
      child: const Center(child: Text('Static Bottom Footer')),
    );
  }

  @override
  Widget body(BuildContext context) {
    return ListView.builder(
      controller: bodyScrollController,
      padding: EdgeInsets.only(top: topSideSize, bottom: 20.0),
      itemCount: 40,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 2.0,
          child: ListTile(
            title: Text('Item #$index'),
            subtitle: const Text('Scroll me!'),
            leading: CircleAvatar(child: Text('$index')),
          ),
        );
      },
    );
  }

  @override
  Widget align(BuildContext context, Widget body, EdgeInsets sideInsets) {
    return Padding(padding: sideInsets, child: body);
  }

  @override
  EdgeInsets sideInsets(EdgeInsets preferredInsets) => preferredInsets;
}
