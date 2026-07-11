import 'package:flutter/material.dart';

/// Breakpoints for adaptive layouts.
abstract final class ResponsiveLayout {
  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 900;

  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= desktopBreakpoint;
  }

  static int gridCrossAxisCount(BuildContext context, {int mobile = 2}) {
    if (isDesktop(context)) {
      return 4;
    }
    if (isTablet(context)) {
      return 3;
    }
    return mobile;
  }
}
