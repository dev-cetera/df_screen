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

void main() {
  group('ScreenBreadCrumbBar', () {
    Future<RouteController> mountWithRouter(
      WidgetTester tester, {
      required List<RouteBuilder> builders,
      required RouteState Function() fallback,
    }) async {
      late RouteController controller;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return RouteManager(
              fallbackRouteState: fallback,
              builders: builders,
              onControllerCreated: (c) => controller = c,
              wrapper: (context, routedChild) {
                return Scaffold(
                  body: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        const ScreenBreadCrumbBar(),
                        Expanded(child: routedChild),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
      await tester.pump();
      return controller;
    }

    RouteBuilder builder(String path) {
      return RouteBuilder(
        routeState: RouteState(Uri.parse(path)),
        builder: (context, state) {
          // Distinct text from the crumb so finders don't collide.
          return _TaggedRoute(routeState: state, tag: 'route:$path');
        },
      );
    }

    /// Finds a crumb (Text inside ScreenBreadCrumbBar) by path text.
    Finder findCrumb(String path) {
      return find.descendant(
        of: find.byType(ScreenBreadCrumbBar),
        matching: find.text(path),
      );
    }

    testWidgets('renders one crumb per route in the navigation stack',
        (tester) async {
      final controller = await mountWithRouter(
        tester,
        builders: [builder('/home'), builder('/about'), builder('/contact')],
        fallback: () => RouteState(Uri.parse('/home')),
      );

      controller.push(RouteState(Uri.parse('/about')));
      await tester.pumpAndSettle();
      controller.push(RouteState(Uri.parse('/contact')));
      await tester.pumpAndSettle();

      expect(findCrumb('/home'), findsOneWidget);
      expect(findCrumb('/about'), findsOneWidget);
      expect(findCrumb('/contact'), findsOneWidget);
    });

    testWidgets('tapping a non-current crumb steps back to that route',
        (tester) async {
      final controller = await mountWithRouter(
        tester,
        builders: [builder('/home'), builder('/about'), builder('/contact')],
        fallback: () => RouteState(Uri.parse('/home')),
      );

      controller.push(RouteState(Uri.parse('/about')));
      await tester.pumpAndSettle();
      controller.push(RouteState(Uri.parse('/contact')));
      await tester.pumpAndSettle();
      expect(controller.currentRouteState.uri.path, '/contact');

      await tester.tap(findCrumb('/about'));
      await tester.pumpAndSettle();
      expect(controller.currentRouteState.uri.path, '/about');
    });

    testWidgets('the current crumb is non-tappable', (tester) async {
      final controller = await mountWithRouter(
        tester,
        builders: [builder('/home'), builder('/about')],
        fallback: () => RouteState(Uri.parse('/home')),
      );

      controller.push(RouteState(Uri.parse('/about')));
      await tester.pumpAndSettle();

      await tester.tap(findCrumb('/about'));
      await tester.pumpAndSettle();
      expect(controller.currentRouteState.uri.path, '/about');
    });
  });
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _TaggedRoute extends StatelessWidget with RouteWidgetMixin {
  @override
  final RouteState? routeState;
  final String tag;
  const _TaggedRoute({required this.routeState, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Text(tag, textDirection: TextDirection.ltr);
  }
}
