import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aula_desktop/utils/color_rgb.dart';

void main() {
  test('rgbChannelsFromColor matches Material orange', () {
    final primary = Colors.orange[500]!;
    final (r, g, b) = rgbChannelsFromColor(primary);
    expect(r, 255);
    expect(g, 152);
    expect(b, 0);
    expect(colorFromRgb(r, g, b), primary);
  });

  test('fullySaturatedColor boosts pale shades', () {
    final pale = Colors.orange[200]!;
    final saturated = fullySaturatedColor(pale);
    expect(HSVColor.fromColor(saturated).saturation, closeTo(1.0, 0.01));
    expect(saturated, isNot(equals(pale)));
  });

  test('snapToMaterialPrimary500 maps wheel orange to primary orange', () {
    final wheelOrange = HSVColor.fromAHSV(1, 36, 1, 1).toColor();
    expect(snapToMaterialPrimary500(wheelOrange), Colors.orange[500]);
  });

  test('snapToMaterialPrimary500 maps pure red to primary red not grey', () {
    final red = colorFromRgb(255, 0, 0);
    expect(snapToMaterialPrimary500(red), Colors.red[500]);
  });

  test('normalizeDeviceColor leaves white unchanged', () {
    expect(normalizeDeviceColor(Colors.white), Colors.white);
  });
}
