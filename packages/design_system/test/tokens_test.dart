import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:teloche_design_system/teloche_design_system.dart';

/// WCAG 2.2 contrast ratio between two opaque colors.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  const textPairs = {
    'text on background': (TelocheColors.onBackground, TelocheColors.background),
    'text on surface': (TelocheColors.onBackground, TelocheColors.surface),
    'muted text on surface': (TelocheColors.onSurfaceMuted, TelocheColors.surface),
    'text on accent': (TelocheColors.onAccent, TelocheColors.accent),
  };

  for (final MapEntry(key: name, value: (foreground, background)) in textPairs.entries) {
    test('$name meets WCAG AA (4.5:1)', () {
      expect(contrast(foreground, background), greaterThanOrEqualTo(4.5));
    });
  }

  test('focus outline stands out from the surface (3:1 for UI components)', () {
    expect(contrast(TelocheColors.focus, TelocheColors.surface), greaterThanOrEqualTo(3));
  });
}
