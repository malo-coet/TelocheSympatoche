import 'package:flutter/painting.dart';

/// Brand palette. Placeholder values until the brand guide is done.
abstract final class TelocheColors {
  static const background = Color(0xFF101217);
  static const surface = Color(0xFF1C1F27);
  static const onBackground = Color(0xFFF4F5F7);
  static const onSurfaceMuted = Color(0xFFB4BAC6);
  static const accent = Color(0xFF8FA6FF);
  static const onAccent = Color(0xFF0B0D12);
  static const focus = Color(0xFFFFD166);
}

/// Spacing scale, in logical pixels.
abstract final class TelocheSpacing {
  static const xs = 4.0;
  static const s = 8.0;
  static const m = 16.0;
  static const l = 24.0;
  static const xl = 48.0;
}

/// Focus indicator: thick outline plus a scale-up, readable from three meters.
abstract final class TelocheFocus {
  static const outlineWidth = 4.0;
  static const scale = 1.06;
  static const radius = 12.0;
}
