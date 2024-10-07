import 'package:flutter/material.dart';
import 'package:thema/thema.dart';

import 'dart:collection';

// TODO: Implement tests after the issue is resolved.
// https://github.com/dart-lang/sdk/issues/55910
void main() {
  // test('Color', () {
  //   final primaryColor = Colors.red;
  //   final secondaryColor = Colors.green;
  //   final accentColor = Colors.blue;

  //   final theme = ColorThemeExt(
  //     primaryColor: primaryColor,
  //     secondaryColor: secondaryColor,
  //     accentColor: accentColor,
  //   );

  //   expect(theme.primaryColor, equals(primaryColor));
  //   expect(theme.secondaryColor, equals(secondaryColor));
  //   expect(theme.accentColor, equals(accentColor));
  // });
}

@Thema()
class ColorThemeExt {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
}

@Thema()
class TextStyleThemeExt {
  final TextStyle primaryTextStyle;
  final TextStyle secondaryTextStyle;
  final TextStyle accentTextStyle;
}

@Thema()
class GradientColorThemeExt {
  final GradientColor primaryGradient;
  final GradientColor secondaryGradient;
  final GradientColor accentGradient;
}

@Thema()
class AppThemeExt {
  final ColorThemeExt color;
  final TextStyleThemeExt textStyle;
  final GradientColorThemeExt gradientColor;
}

class GradientColor {
  const GradientColor({
    required this.colors,
    required this.stops,
  }) : assert(
          colors.length == stops.length &&
              colors.length >= 2 &&
              stops.length >= 2,
          'colors and stops must have the same length and at least 2 elements',
        );

  final List<Color> colors;
  final List<double> stops;

  /// See also: [Gradient]
  static GradientColor? lerp(GradientColor? a, GradientColor? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    if (a == null) {
      return b!.scale(t);
    }
    if (b == null) {
      return a.scale(1.0 - t);
    }
    final stops = SplayTreeSet<double>()
      ..addAll(a.stops)
      ..addAll(b.stops);
    final interpolatedStops = stops.toList(growable: false);
    final interpolatedColors = interpolatedStops
        .map<Color>(
          (double stop) => Color.lerp(
            _sample(a.colors, a.stops, stop),
            _sample(b.colors, b.stops, stop),
            t,
          )!,
        )
        .toList(growable: false);
    return GradientColor(
      colors: interpolatedColors,
      stops: interpolatedStops,
    );
  }

  static Color _sample(List<Color> colors, List<double> stops, double t) {
    if (t <= stops.first) {
      return colors.first;
    }
    if (t >= stops.last) {
      return colors.last;
    }
    final index = stops.lastIndexWhere((double s) => s <= t);
    return Color.lerp(
      colors[index],
      colors[index + 1],
      (t - stops[index]) / (stops[index + 1] - stops[index]),
    )!;
  }

  GradientColor scale(double factor) {
    return GradientColor(
      colors: colors.map((color) => Color.lerp(null, color, factor)!).toList(),
      stops: stops,
    );
  }
}
