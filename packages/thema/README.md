<div align="center">

# thema

thema reduces the boilerplate code required to create ThemeExtension classes with macros.

</div>

> [!CAUTION]
> This package is experimental because of [the Dart macro system][macro-spec] is currently under development.
> DO NOT USE on production codes.

[macro-spec]: https://github.com/dart-lang/language/blob/main/working/macros/feature-specification.md

---

## Contents

- [Requirements](#requirements)
- [Setup](#setup)
- [Usage](#usage)
- [Feature requests](#feature-requests)
- [Bug reports](#bug-reports)

## Requirements

- Dart dev channel
- Flutter master channel

For more information, refer to the [Macros][macros] documentation.

[macros]: https://dart.dev/language/macros

## Setup

1. Edit SDK constraints in `pubspec.yaml`:

```yaml
environment:
  sdk: ">=3.6.0-0 <4.0.0"
```

2. Enable the experiment in `analysis_options.yaml`:

```yaml
analyzer:
  enable-experiment:
    - macros
    - enhanced-parts
```

## Usage

Define a class with the `@Thema` annotation:

```dart
@Thema()
class ColorThemeExt {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
}
```

thema supports custom theme classes:

```dart
class GradientColor {
  // You should implement the `lerp` static method.
  static GradientColor? lerp(GradientColor? a, GradientColor? b, double t) {
    // ...
  }
}

@Thema()
class GradientColorThemeExt {
  final GradientColor primaryGradient;
  final GradientColor secondaryGradient;
  final GradientColor accentGradient;
}
```

thema also supports nested ThemeExtension classes:

```dart
@Thema()
class AppThemeExt {
  final ColorThemeExt color;
  final GradientColorThemeExt gradientColor;
}
```

## Feature requests

If you have any feature requests, please create [an issue from this template](https://github.com/ronnnnn/thema/issues/new?&labels=feat&template=feat.yml).

## Bug reports

If you find any bugs, please create [an issue from this template](https://github.com/ronnnnn/thema/issues/new?&labels=bug&template=bug.yml).

## Contributing

Welcome your contributions!!
Please read [CONTRIBUTING](https://github.com/ronnnnn/thema/blob/main/CONTRIBUTING.md) docs before submitting your PR.
