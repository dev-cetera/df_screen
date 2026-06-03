//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Copyright © dev-cetera.com & contributors.
//
// The use of this source code is governed by an MIT-style license described in
// the LICENSE file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:flutter/foundation.dart';

import 'package:flutter/widgets.dart'
    show BuildContext, MediaQuery, MediaQueryData, WidgetsBinding;

import 'package:device_info_plus/device_info_plus.dart' as device_info_plus;

import '/src/layout_breakpoints.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class CurrentPlatform {
  //
  //
  //

  final _deviceInfoPlugin = device_info_plus.DeviceInfoPlugin();
  String _name = 'UNKNOWN';
  String get name => _name;

  //
  //
  //

  CurrentPlatform._();

  //
  //
  //

  static Future<CurrentPlatform> create() async {
    final instance = CurrentPlatform._();
    instance._name = await instance.getName();
    return instance;
  }

  //
  //
  //

  bool supportsPushNotifications() {
    if (kIsWeb) {
      return [
        'SAFARI ON MACOS',
        'SAFARI ON IOS',
        'CHROME ON MACOS',
        'CHROME ON WINDOWS',
        'CHROME ON ANDROID',
      ].contains(name);
    }
    return true;
  }

  //
  //
  //

  /// NOTE: Only supports Android, iOS, MacOS, Windows, Web.
  Future<String> getName() async {
    if (kIsWeb) {
      final info = await _deviceInfoPlugin.webBrowserInfo;
      final browserName = info.browserName.name.toUpperCase();
      if (isOsMacOs) {
        return '$browserName ON MACOS';
      }
      if (isOsWindows) {
        return '$browserName ON WINDOWS';
      }
      if (isOsIos) {
        return '$browserName ON IOS';
      }
      if (isOsAndroid) {
        return '$browserName ON ANDROID';
      }
    } else {
      if (isOsAndroid) {
        final info = await _deviceInfoPlugin.androidInfo;
        return info.model;
      }
      if (isOsIos) {
        final info = await _deviceInfoPlugin.iosInfo;
        return info.model;
      }
    }
    return 'UNKNOWN';
  }

  static final isOsIos = defaultTargetPlatform == TargetPlatform.iOS;
  static final isOsAndroid = defaultTargetPlatform == TargetPlatform.android;
  static final isOsMobile = isOsIos || isOsAndroid;
  static final isOsWindows = defaultTargetPlatform == TargetPlatform.windows;
  static final isOsMacOs = defaultTargetPlatform == TargetPlatform.macOS;
  static final isOsLinux = defaultTargetPlatform == TargetPlatform.linux;
  static final isOsApple = isOsIos || isOsMacOs;
  static final isOsDeskop = isOsWindows || isOsMacOs || isOsLinux;

  /// Uses the platform's *primary view* to decide whether the window is
  /// mobile-sized. Static — prefer [isWindowSizeMobileFor] in widget code so
  /// nested apps (mini-app frames, embeddings) get an accurate answer.
  static bool get isTablet => isOsMobile && isWindowSizeTabletOrDesktop;

  /// Uses the platform's *primary view* to decide whether the window is
  /// mobile-sized. Static — prefer [isWindowSizeMobileFor] when a
  /// [BuildContext] is available.
  static bool get isMobile => isOsMobile && isWindowSizeMobile;

  static bool get isDesktop => isOsWindows || isOsMacOs || isOsLinux;

  /// True when the platform's primary view's shortest side is below
  /// [LayoutBreakpoints.global.mobileMaxShortestSide].
  static bool get isWindowSizeMobile {
    final firstView =
        WidgetsBinding.instance.platformDispatcher.views.firstOrNull;
    if (firstView == null) {
      throw StateError('No platform views available.');
    }
    final data = MediaQueryData.fromView(firstView);
    return data.size.shortestSide <
        LayoutBreakpoints.global.mobileMaxShortestSide;
  }

  static bool get isWindowSizeTabletOrDesktop => !isWindowSizeMobile;

  /// Context-aware variant of [isWindowSizeMobile]. Reads the nearest
  /// [MediaQuery] so embedded apps with a constrained size are classified
  /// correctly.
  ///
  /// Pass [breakpoints] to override the process-wide default for this call.
  static bool isWindowSizeMobileFor(
    BuildContext context, {
    LayoutBreakpoints? breakpoints,
  }) {
    final size = MediaQuery.sizeOf(context);
    final bp = breakpoints ?? LayoutBreakpoints.global;
    return size.shortestSide < bp.mobileMaxShortestSide;
  }

  /// Context-aware variant of [isMobile].
  static bool isMobileFor(
    BuildContext context, {
    LayoutBreakpoints? breakpoints,
  }) {
    return isOsMobile && isWindowSizeMobileFor(context, breakpoints: breakpoints);
  }
}
