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
    final routeServiceOption = DI.global<ScreenRouteManger>();
    if (routeServiceOption.isNone()) {
      return const SizedBox.shrink();
    }
    final routeService = routeServiceOption.unwrap();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(32),
      ),
      height: height ?? 32.sc,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.sc),
        child: PodBuilder(
          pod: routeService.pScreenBreadcrumbs,
          builder: (context, screenBreadcrumbsSnapshot) {
            final screenBreadcrumbs = screenBreadcrumbsSnapshot.value;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
                children: [
                  ...?screenBreadcrumbs?.nonNulls
                      .map((e) => e.path)
                      .nonNulls
                      .mapIndexed((n, path) {
                        final last = n == screenBreadcrumbs.nonNulls.length - 1;
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap:
                                !last
                                    ? () => routeService.goFromFront(n + 1)
                                    : null,
                            child: Text(
                              path,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color:
                                    last
                                        ? Theme.of(
                                          context,
                                        ).colorScheme.onSurface.withAlpha(125)
                                        : Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
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
