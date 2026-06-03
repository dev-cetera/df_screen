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
  group('AdaptiveScrollBuilder', () {
    testWidgets('reports percentage 1.0 when scroll offset is 0',
        (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);

      final reportedPercentages = <double>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  AdaptiveScrollBuilder(
                    controller: controller,
                    expandedSize: 200,
                    collapsedSize: 100,
                    builder: (context, percentage, child) {
                      reportedPercentages.add(percentage);
                      return Container(
                        height: 200,
                        color: const Color(0xFF000000),
                      );
                    },
                  ),
                  const SizedBox(height: 2000),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(reportedPercentages.last, 1.0);
    });

    testWidgets('reports percentage 0.0 when scrolled past the range',
        (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);

      double? lastReportedPercentage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  AdaptiveScrollBuilder(
                    controller: controller,
                    expandedSize: 200,
                    collapsedSize: 100,
                    builder: (context, percentage, child) {
                      lastReportedPercentage = percentage;
                      return const SizedBox(height: 200);
                    },
                  ),
                  const SizedBox(height: 2000),
                ],
              ),
            ),
          ),
        ),
      );
      controller.jumpTo(500);
      await tester.pump();
      expect(lastReportedPercentage, 0.0);
    });

    testWidgets('returns 1.0 when expandedSize == collapsedSize (zero range)',
        (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);

      double? lastReportedPercentage;

      await tester.pumpWidget(
        MaterialApp(
          home: AdaptiveScrollBuilder(
            controller: controller,
            expandedSize: 100,
            collapsedSize: 100,
            builder: (context, percentage, child) {
              lastReportedPercentage = percentage;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pump();
      expect(lastReportedPercentage, 1.0);
    });
  });
}
