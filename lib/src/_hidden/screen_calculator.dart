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

/// Calculates the size, orientation and aspect ratio of a screen.
class ScreenCalculator {
  //
  //
  //

  /// The longest side of the screen.
  double get longest => _longest;
  late double _longest;

  /// The shortest side of the screen.
  double get shortest => _shortest;
  late double _shortest;

  /// The size of the screen.
  ScreenSize get size => _size;
  late ScreenSize _size;

  /// The width of the screen.
  double get width => _size.width;

  /// The height of the screen.
  double get height => _size.height;

  /// The size of the screen with the longest side as the width.
  ScreenSize get sizeVerticalBias => _sizeVerticalBias;
  late ScreenSize _sizeVerticalBias;

  /// The size of the screen with the shortest side as the width.
  ScreenSize get sizeHorizontalBias => _sizeHorizontalBias;
  late ScreenSize _sizeHorizontalBias;

  /// Whether the screen is horizontal.
  bool get isHorizontal => _isHorizontal;
  late bool _isHorizontal;

  /// Whether the screen is vertical.
  bool get isVertical => _isVertical;
  late bool _isVertical;

  /// Whether the screen is neither horizontal nor vertical, i.e. a square.
  bool get isNeitherHorizontalNorVertical => _isNeitherHorizontalNorVertical;
  late bool _isNeitherHorizontalNorVertical;

  /// Whether the aspect ratio of the screen is that of a mobile phone.
  bool get isAspectRatioMobile =>
      sizeVerticalBias.aspectRatio > MIN_MOBILE_ASPECT_RATIO;

  //
  //
  //

  ScreenCalculator(double maxWidth, double maxHeight) {
    _longest = maxWidth >= maxHeight ? maxWidth : maxHeight;
    _shortest = maxWidth <= maxHeight ? maxWidth : maxHeight;
    _size = ScreenSize(maxWidth, maxHeight);
    _sizeVerticalBias = ScreenSize(_longest, _shortest);
    _sizeHorizontalBias = ScreenSize(_shortest, _longest);
    _isHorizontal = _size.aspectRatio > 1.0;
    _isVertical = _size.aspectRatio < 1.0;
    _isNeitherHorizontalNorVertical = _size.aspectRatio == 1.0;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Represents the size of a screen.
class ScreenSize {
  final double width, height;
  const ScreenSize(this.width, this.height);
  double get aspectRatio {
    if (height != 0.0) return width / height;
    if (width > 0.0) return double.infinity;
    if (width < 0.0) return double.negativeInfinity;
    return 0.0;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// The smallest of the following common aspect ratios for mobile phones (4.0 / 3.0)
const MIN_MOBILE_ASPECT_RATIO = 4.0 / 3.0;

/// The smallest of the following common aspect ratios for mobile phones (4.0 / 3.0)
double get minMobileAspectRatio => {
  // Samsungs
  16.0 / 10.0,
  // Pixels, Samsungs
  16.0 / 9.0,
  // Pixels, most iPhones before 2018
  18.0 / 9.0,
  // Pixels
  18.5 / 9.0,
  18.7 / 9.0,
  19.0 / 10.0,
  // Pixels
  19.0 / 9.0,
  // Pixels and most iPhones after 2018
  19.5 / 9.0,
  3.0 / 2.0,
  // Old iPhones, and many tablets!
  4.0 / 3.0,
  5.0 / 3.0,
  // Samsungs
  2.10 / 1,
  20.0 / 9.0,
  193 / 90,
}.reduce((a, b) => a <= b ? a : b);

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

extension CalculatorOnScreenSizeExtension on ScreenSize {
  /// The calculator for the screen size.
  ScreenCalculator get calculator => ScreenCalculator(width, height);
}
