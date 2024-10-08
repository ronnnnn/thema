<div align="center">

# thema

thema reduces the boilerplate code required to create ThemeExtension classes with macros.

[![check][badge-check]](https://github.com/ronnnnn/thema/actions/workflows/check.yaml)
[![pub][badge-pub]](https://pub.dev/packages/thema)
[![license][badge-license]](https://github.com/ronnnnn/thema/blob/main/packages/thema/LICENSE)

[badge-check]: https://img.shields.io/github/actions/workflow/status/ronnnnn/thema/check.yaml?style=for-the-badge&logo=github%20actions&logoColor=%232088FF&color=gray&link=https%3A%2F%2Fgithub.com%2Fronnnnn%2Fthema%2Factions%2Fworkflows%2Fcheck.yaml
[badge-pub]: https://img.shields.io/pub/v/thema?style=for-the-badge&logo=dart&logoColor=%230175C2&color=gray&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fthema
[badge-license]: https://img.shields.io/badge/license-mit-green?style=for-the-badge&logo=github&logoColor=%23181717&color=gray&link=https%3A%2F%2Fgithub.com%2Fronnnnn%2Fthema%2Fblob%2Fmain%2Fpackages%2Fthema%2FLICENSE

</div>

> [!CAUTION]
> This package is experimental because [the Dart macro system][macro-spec] is currently under development.<br>
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

If you have any feature requests, please create [an issue from this template](https://github.com/ronnnnn/thema/issues/new?&labels=feat&template=feat.yaml).

## Bug reports

If you find any bugs, please create [an issue from this template](https://github.com/ronnnnn/thema/issues/new?&labels=bug&template=bug.yaml).

## Contributing

Welcome your contributions!!
Please read [CONTRIBUTING](https://github.com/ronnnnn/thema/blob/main/CONTRIBUTING.md) docs before submitting your PR.
