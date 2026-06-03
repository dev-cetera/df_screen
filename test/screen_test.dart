//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Copyright © dev-cetera.com & contributors.
// MIT license. See https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:df_router/df_router.dart';
import 'package:df_screen/df_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '_helpers.dart';

void main() {
  group('Screen.routeState', () {
    test('defaults to null when not passed', () {
      const screen = TestScreen();
      expect(screen.routeState, isNull);
    });

    test('round-trips a typed RouteState', () {
      final state = RouteState<Object?>(Uri.parse('/test'));
      final screen = TestScreen(routeState: state);
      expect(screen.routeState, isNotNull);
      expect(screen.routeState!.uri.path, '/test');
    });
  });

  group('Screen.controllerTimeout', () {
    test('defaults to Duration.zero', () {
      const screen = TestScreen();
      expect(screen.controllerTimeout, Duration.zero);
    });

    test('accepts a custom timeout', () {
      const screen = TestScreen(
        controllerTimeout: Duration(minutes: 5),
      );
      expect(screen.controllerTimeout, const Duration(minutes: 5));
    });

    test('accepts null for live-forever caching', () {
      const screen = TestScreen(controllerTimeout: null);
      expect(screen.controllerTimeout, isNull);
    });
  });

  group('RouteWidgetMixin contract', () {
    test('Screen satisfies RouteWidgetMixin<TExtra>', () {
      const screen = TestScreen();
      expect(screen, isA<RouteWidgetMixin>());
    });
  });
}
