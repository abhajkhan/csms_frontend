import 'package:flutter/material.dart';

enum AppBreakpoint { mobile, tablet, desktop }

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  static AppBreakpoint breakpointFor(double width) => switch (width) {
    < 600 => AppBreakpoint.mobile,
    < 1024 => AppBreakpoint.tablet,
    _ => AppBreakpoint.desktop,
  };

  static bool isMobile(BuildContext context) =>
      breakpointFor(MediaQuery.sizeOf(context).width) == AppBreakpoint.mobile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          switch (breakpointFor(constraints.maxWidth)) {
            AppBreakpoint.mobile => mobile,
            AppBreakpoint.tablet => tablet,
            AppBreakpoint.desktop => desktop,
          },
    );
  }
}
