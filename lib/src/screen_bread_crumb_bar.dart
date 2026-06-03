//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by dev-cetera.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:df_pod/df_pod.dart';
import 'package:flutter/material.dart';

import '../df_screen.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ScreenBreadCrumbBar extends StatelessWidget {
  //
  //
  //

  final double? height;

  //
  //
  //

  const ScreenBreadCrumbBar({super.key, this.height});

  //
  //
  //

  @override
  Widget build(BuildContext context) {
    final routeController = RouteController.of(context);
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(color: theme.colorScheme.primary.withAlpha(32)),
      height: height ?? 32.sc,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.sc),
        child: PodBuilder(
          pod: routeController.pNavigationState,
          builder: (context, snapshot) {
            final navState = routeController.pNavigationState.getValue();
            final routes = navState.routes;
            final currentIndex = navState.index;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
                children: [
                  ...routes.mapIndexed((n, route) {
                    final path = route.uri.path;
                    final last = n == routes.length - 1;
                    final isCurrent = n == currentIndex;
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isCurrent
                            ? null
                            : () => routeController.step(n - currentIndex),
                        child: Text(
                          path,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: last
                                ? theme.colorScheme.onSurface.withAlpha(125)
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
