import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

/// Material primary swatches at shade 500 — matches the official Aula palette.
final List<Color> materialPrimary500 = [
  for (final swatch in ColorTools.primaryColors) swatch[500]!,
];

/// Extract 8-bit sRGB channels for device protocols.
(int, int, int) rgbChannelsFromColor(Color color) {
  return (
    (color.r * 255.0).round().clamp(0, 255),
    (color.g * 255.0).round().clamp(0, 255),
    (color.b * 255.0).round().clamp(0, 255),
  );
}

Color colorFromRgb(int r, int g, int b) {
  return Color.fromARGB(255, r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255));
}

/// Boosts chromatic colors to full HSV saturation while keeping hue and value.
///
/// White, gray, and black are left unchanged because they have no meaningful hue.
Color fullySaturatedColor(Color color) {
  final hsv = HSVColor.fromColor(color);
  if (hsv.value <= 0 || hsv.saturation < 1 / 255.0) {
    return color;
  }
  if (hsv.saturation >= 1.0) {
    return color;
  }
  return hsv.withSaturation(1.0).toColor();
}

/// Snaps a chromatic color to the nearest Material primary-500 swatch.
///
/// The keyboard reproduces this preset palette accurately; arbitrary RGB values
/// tend to look washed out or hue-shifted on the LEDs.
Color snapToMaterialPrimary500(Color color) {
  final saturated = fullySaturatedColor(color);
  final sourceHsv = HSVColor.fromColor(saturated);
  if (sourceHsv.saturation < 1 / 255.0) {
    return saturated;
  }

  Color? best;
  var bestHueDistance = double.infinity;
  final sourceHue = sourceHsv.hue;

  for (final candidate in materialPrimary500) {
    final candidateHsv = HSVColor.fromColor(candidate);
    // Neutral swatches (grey/brown/black/white) report hue 0 and must not
    // win hue matching for saturated colors like pure red.
    if (candidateHsv.saturation < 1 / 255.0) continue;

    final candidateHue = candidateHsv.hue;
    var hueDistance = (sourceHue - candidateHue).abs();
    if (hueDistance > 180) {
      hueDistance = 360 - hueDistance;
    }
    if (hueDistance < bestHueDistance) {
      bestHueDistance = hueDistance;
      best = candidate;
    }
  }

  return best ?? saturated;
}

/// Full normalization pipeline for keyboard lighting colors.
Color normalizeDeviceColor(Color color) => snapToMaterialPrimary500(color);

(int, int, int) deviceRgbChannelsFromColor(Color color) {
  return rgbChannelsFromColor(normalizeDeviceColor(color));
}
