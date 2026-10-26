import 'package:flutter/material.dart';

import 'tokens.dart';

/// Default (dark) theme, designed for a television.
ThemeData telocheTheme() {
  final colors = ColorScheme.fromSeed(seedColor: TelocheColors.accent, brightness: Brightness.dark).copyWith(
    primary: TelocheColors.accent,
    onPrimary: TelocheColors.onAccent,
    surface: TelocheColors.surface,
    onSurface: TelocheColors.onBackground,
  );
  return ThemeData(
    colorScheme: colors,
    scaffoldBackgroundColor: TelocheColors.background,
    textTheme: Typography.whiteMountainView.apply(
      bodyColor: TelocheColors.onBackground,
      displayColor: TelocheColors.onBackground,
    ),
  );
}
