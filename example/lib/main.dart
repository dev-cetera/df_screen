import 'package:df_screen/df_screen.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Adaptive Screen', home: ExampleScreen());
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

// A controller is like a controller and should hold the business logic
// that is exclusive to the screen.
final class ExampleScreenController extends ScreenController {
  ExampleScreenController(super.screen, super.state);
}

final class ExampleScreenState extends AdaptiveScreenState<ExampleScreen,
    Object?, ExampleScreenController> {
  @override
  Widget wideBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('WIDE BODY!!!')],
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('NARROW BODY!!!')],
      ),
    );
  }

  @override
  EdgeInsets sideInsets(EdgeInsets preferredInsets) {
    // Remove the top insets.
    return preferredInsets.copyWith(top: 0.0);
  }

  @override
  PreferredSizeWidget leftSide(BuildContext context, double leftInsets) {
    return PreferredSize(
      preferredSize: Size(leftInsets + 80, double.infinity),
      child: Container(color: Colors.orange.withAlpha(128)),
    );
  }

  @override
  PreferredSizeWidget rightSide(BuildContext context, double rightInsets) {
    return PreferredSize(
      preferredSize: Size(rightInsets + 80, double.infinity),
      child: Container(color: Colors.green.withAlpha(128)),
    );
  }

  @override
  PreferredSizeWidget topSide(BuildContext context, double topInsets) {
    return PreferredSize(
      preferredSize: Size(double.infinity, topInsets + 80),
      child: Container(color: Colors.yellow.withAlpha(128)),
    );
  }

  @override
  PreferredSizeWidget bottomSide(BuildContext context, double bottomInsets) {
    return PreferredSize(
      preferredSize: Size(double.infinity, bottomInsets + 80),
      child: Container(color: Colors.blue.withAlpha(128)),
    );
  }
}
