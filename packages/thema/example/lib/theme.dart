import 'package:thema/thema.dart';
import 'package:flutter/material.dart';
import 'package:thema_example/gradient_color.dart';

// WORKAROUND:
// Separate file from main.dart.
// https://github.com/dart-lang/sdk/issues/55910

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
