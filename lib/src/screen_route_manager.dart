//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. Use of this
// source code is governed by an an MIT-style license that can be found in the
// LICENSE file located in this project's root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

// Flutter.
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart' show kIsWeb, nonVirtual, protected;
import 'package:flutter/cupertino.dart' show CupertinoPage;
import 'package:flutter/material.dart' show MaterialPage;

// DF.
import 'package:df_collection/df_collection.dart';
import 'package:df_screen_core/df_screen_core.dart';
import 'package:df_pod/df_pod.dart';

// GoRouter.
import 'package:go_router/go_router.dart';

// Local.
import 'screen_view.dart';
import 'screen.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class ScreenRouteManager extends _ScreenRouteManager {
  //
  //
  //

  final String errorPath;
  final Widget? rootPathWidget;

  //
  //
  //

  ScreenRouteManager({
    required super.isLoggedIn,
    required super.isVerified,
    required super.findScreen,
    required super.generatedScreenRoutes,
    super.defaultOnLoginScreenConfiguration,
    required super.defaultOnLogoutScreenConfiguration,
    this.errorPath = '/error',
    this.rootPathWidget,
  });

  //
  //
  //

  @override
  GoRouter get router => _router;

  //
  //
  //

  final _navigatorKey = GlobalKey<NavigatorState>();

  //
  //
  //

  late final _router = GoRouter(
    errorPageBuilder: (context, state) {
      return super.commonPageBuilder(
        context,
        state,
        errorPath,
      );
    },
    redirect: (context, state) async {
      await ScreenView.captureScreen(context);
      debugPrint('[RouteManager] Redirecting ${state.fullPath}');
      return null;
    },
    initialLocation: super.defaultConfiguration.path,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return child;
        },
        navigatorKey: _navigatorKey,
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => rootPathWidget ?? const SizedBox(),
            routes: [
              ...super.generatedScreenRoutes.map(
                (route) {
                  final path = route.path;
                  return GoRoute(
                    path: path,
                    pageBuilder: (context, state) {
                      _updateBreadcrumbs(state);
                      return commonPageBuilder(
                        context,
                        state,
                        path,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );

  void _updateBreadcrumbs(GoRouterState state) {
    final extra = state.extra;
    if (extra is ModelScreenConfiguration && _pScreenBreadcrumbs.value.lastOrNull != extra) {
      _pScreenBreadcrumbs.update((e) {
        return (e..add(extra)).reversed.take(4).toList().reversed.toList();
      });
    }
  }

  //
  //
  //

  @override
  void go(ModelScreenConfiguration configuration) {
    ModelScreenConfiguration targetConfiguration;
    if (super.hasPermissionsToGoTo(configuration)) {
      targetConfiguration = configuration;
    } else {
      targetConfiguration = super.defaultConfiguration;
    }
    super.go(targetConfiguration);
  }

  //
  //
  //

  Future<void> goFromFront(int index) async {
    final chunk = super.pScreenBreadcrumbs.value.toList();
    final i = index;
    if (i >= 0 && i < chunk.length) {
      chunk.removeRange(i, chunk.length);
      await _pScreenBreadcrumbs.set(chunk);
      final to = chunk.last;
      go(to);
    }
  }

  //
  //
  //

  Future<void> goFromBack(int index) async {
    final chunk = super.pScreenBreadcrumbs.value.toList();
    final i = chunk.length - index;
    if (i >= 0 && i < chunk.length) {
      chunk.removeRange(i, chunk.length);
      await _pScreenBreadcrumbs.set(chunk);
      final to = chunk.last;
      go(to);
    }
  }

  //
  //
  //

  Future<void> goBack() async {
    final screenBreadcrumbs = super.pScreenBreadcrumbs.value;
    if (screenBreadcrumbs.length > 1) {
      await _pScreenBreadcrumbs.update((e) => e..removeLast());
      final lastConfiguration = screenBreadcrumbs.lastOrNull;
      if (lastConfiguration != null) {
        go(lastConfiguration);
        return;
      }
    }
    go(super.defaultConfiguration);
  }

  //
  //
  //

  Future<void> goBackTo(ModelScreenConfiguration untilConfiguration) async {
    final chunk = super.pScreenBreadcrumbs.value.toList();
    final screenBreadcrumbs = super.pScreenBreadcrumbs.value.toList().reversed;
    for (final breadcrumb in screenBreadcrumbs) {
      if (breadcrumb == untilConfiguration) {
        break;
      }
      chunk.removeLast();
    }
    await super._pScreenBreadcrumbs.set(chunk);
    final to = chunk.lastOrNull;
    if (to != null) {
      go(to);
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract base class _ScreenRouteManager {
  //
  //
  //

  final bool Function() isLoggedIn;
  final bool Function() isVerified;
  final List<GoRoute> generatedScreenRoutes;
  final ModelScreenConfiguration? defaultOnLoginScreenConfiguration;
  final ModelScreenConfiguration defaultOnLogoutScreenConfiguration;
  final Screen? Function({
    required ModelScreenConfiguration configuration,
    required bool loggedIn,
    required bool verified,
  }) findScreen;

  //
  //
  //

  _ScreenRouteManager({
    required this.isLoggedIn,
    required this.isVerified,
    required this.generatedScreenRoutes,
    required this.defaultOnLoginScreenConfiguration,
    required this.defaultOnLogoutScreenConfiguration,
    required this.findScreen,
  });

  //
  //
  //

  final _pScreenBreadcrumbs = GlobalPod<List<ModelScreenConfiguration>>([]);
  PodListenable<List<ModelScreenConfiguration>> get pScreenBreadcrumbs => _pScreenBreadcrumbs;

  //
  //
  //

  ModelScreenConfiguration get defaultConfiguration => isLoggedIn()
      ? defaultOnLoginScreenConfiguration ?? defaultOnLogoutScreenConfiguration
      : defaultOnLogoutScreenConfiguration;

  //
  //
  //

  @protected
  GoRouter get router;

  //
  //
  //

  void go(ModelScreenConfiguration configuration) {
    final queryParameters = configuration.args
            ?.map(
              (k, v) => MapEntry(
                k is String ? k : null,
                v is String ? v : null,
              ),
            )
            .nonNulls
            .nullIfEmpty ??
        {};
    final to = Uri.decodeComponent(
      Uri(
        pathSegments: [configuration.path].nonNulls,
        queryParameters: queryParameters,
      ).toString(),
    );
    router.go(to, extra: configuration);
  }

  //
  //
  //

  @nonVirtual
  bool hasPermissionsToGoTo(ModelScreenConfiguration configuration) {
    final test = () {
      if (_isInitialPage && configuration.isRedirectable == false) {
        return false;
      }
      final loggedIn = isLoggedIn();
      if (!loggedIn && configuration.isAccessibleOnlyIfLoggedIn == true) {
        return false;
      }
      if (loggedIn && configuration.isAccessibleOnlyIfLoggedOut == true) {
        return false;
      }
      return true;
    }();
    return test;
  }

  var _isInitialPage = true;

  //
  //
  //

  @nonVirtual
  @protected
  Page<dynamic> commonPageBuilder(
    BuildContext context,
    GoRouterState state,
    String requestedPath,
  ) {
    var result = _emptyPage();
    final requestedPage = _getPageByRegisteredRoute(
      context,
      state,
      _getRegisteredRouteByPath(requestedPath),
    );
    final requestedScreen = _getScreenFromPage(requestedPage);
    final requestedConfiguration = requestedScreen?.configuration;
    if (requestedConfiguration != null && hasPermissionsToGoTo(requestedConfiguration)) {
      _isInitialPage = false;
      final targetScreen = findScreen(
        configuration: requestedConfiguration,
        loggedIn: isLoggedIn(),
        verified: isVerified(),
      );
      final targetConfiguration = targetScreen?.configuration;
      if (targetConfiguration != null) {
        final title = requestedScreen?.configuration?.title;
        if (title != null && title.isNotEmpty) {
          _setHtmlTitle(title);
        }
        result = requestedPage!;
      } else {
        final newConfiguration = defaultConfiguration;
        Future.microtask(() {
          go(newConfiguration);
        });
      }
    }
    return result;
  }

  //
  //
  //

  GoRoute? _getRegisteredRouteByPath(String? path) {
    final route = generatedScreenRoutes.firstWhereOrNull((e) => e.path == path);
    return route;
  }

  //
  //
  //

  Page<dynamic>? _getPageByRegisteredRoute(
    BuildContext context,
    GoRouterState state,
    GoRoute? route,
  ) {
    final page = route?.pageBuilder?.call(context, state);
    return page;
  }

  //
  //
  //

  Screen? _getScreenFromPage(Page<dynamic>? page) {
    Widget? screen;
    if (page is CustomTransitionPage) {
      screen = page.child;
    } else if (page is MaterialPage) {
      screen = page.child;
    } else if (page is CupertinoPage) {
      screen = page.child;
    } else {
      try {
        screen = (page as dynamic).child as Widget;
      } catch (e) {
        debugPrint('[RouteManager] Error: "page" has no "child" widget');
      }
    }
    if (screen is Screen) {
      return screen;
    } else {
      debugPrint('[RouteManager] Error: "screen" is not of type "Screen"');
    }
    return null;
  }

  //
  //
  //

  Page<dynamic> _emptyPage() {
    return const NoTransitionPage(child: SizedBox.shrink());
  }

  //
  //
  //

  void _setHtmlTitle(String newTitle) {
    if (kIsWeb) {}
  }
}
