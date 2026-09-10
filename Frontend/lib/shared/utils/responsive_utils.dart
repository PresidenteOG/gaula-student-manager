import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Central responsive utility for GAULA cross-platform layout.
/// Use these helpers to keep web and mobile branches consistent.
class GaulaResponsive {
  GaulaResponsive._();

  /// Returns true when running on a mobile-width screen (< 600dp breakpoint).
  static bool isM(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isMobile;

  /// Returns [mobile] value when on mobile, [web] otherwise.
  static T when<T>(BuildContext context, {required T web, required T mobile}) =>
      isM(context) ? mobile : web;

  /// Adaptive padding — 16px on mobile, 40px on web/desktop.
  static EdgeInsets screenPad(BuildContext context) =>
      EdgeInsets.all(isM(context) ? 16.0 : 40.0);

  /// Adaptive horizontal + vertical padding.
  static EdgeInsets pad(BuildContext context,
      {double webH = 40, double webV = 40, double mobH = 16, double mobV = 20}) =>
      isM(context)
          ? EdgeInsets.symmetric(horizontal: mobH, vertical: mobV)
          : EdgeInsets.symmetric(horizontal: webH, vertical: webV);

  /// Adaptive font size.
  static double fontSize(BuildContext context,
      {required double web, required double mobile}) =>
      isM(context) ? mobile : web;

  /// Adaptive spacing height.
  static double spacing(BuildContext context,
      {required double web, required double mobile}) =>
      isM(context) ? mobile : web;

  /// Grid max cross-axis extent: smaller on mobile.
  static double gridExtent(BuildContext context,
      {required double web, required double mobile}) =>
      isM(context) ? mobile : web;
}
