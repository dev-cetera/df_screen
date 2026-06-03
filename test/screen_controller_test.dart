//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Copyright © dev-cetera.com & contributors.
// MIT license. See https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:df_screen/df_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScreenController.ready / runInit lifecycle', () {
    test('ready is not completed before runInit', () {
      final c = _BareController();
      expect(c.isReady, isFalse);
    });

    test('ready completes after a synchronous initController', () async {
      final c = _BareController();
      await c.runInit();
      expect(c.isReady, isTrue);
      await expectLater(c.ready, completes);
    });

    test('ready completes after an async initController', () async {
      final c = _DelayedController();
      final future = c.runInit();
      expect(c.isReady, isFalse);
      await future;
      expect(c.isReady, isTrue);
    });

    test('runInit is idempotent (calling twice does not re-complete)',
        () async {
      final c = _CountingInitController();
      await c.runInit();
      await c.runInit();
      expect(c.initCalls, 1, reason: 'second runInit should be a no-op');
    });

    test('ready surfaces an exception thrown inside initController', () async {
      final c = _ThrowingController();
      await c.runInit();
      expect(c.isReady, isTrue, reason: 'ready completes even on error');
      await expectLater(c.ready, throwsA(isA<StateError>()));
    });
  });

  group('ScreenController.dispose', () {
    test('runs without arguments and is overridable', () {
      final c = _DisposeTrackingController();
      c.dispose();
      expect(c.disposed, isTrue);
    });
  });
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

base class _BareController extends ScreenController {
  _BareController() : super(null, null);
}

base class _DelayedController extends ScreenController {
  _DelayedController() : super(null, null);

  @override
  Future<void> initController() async {
    await super.initController();
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

base class _CountingInitController extends ScreenController {
  _CountingInitController() : super(null, null);

  int initCalls = 0;

  @override
  Future<void> initController() async {
    await super.initController();
    initCalls++;
  }
}

base class _ThrowingController extends ScreenController {
  _ThrowingController() : super(null, null);

  @override
  Future<void> initController() async {
    await super.initController();
    throw StateError('boom');
  }
}

base class _DisposeTrackingController extends ScreenController {
  _DisposeTrackingController() : super(null, null);

  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}
