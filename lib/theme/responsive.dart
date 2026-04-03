import 'package:flutter/material.dart';

/// ══════════════════════════════════════════════════════════
///  RESPONSIVE BREAKPOINTS & HELPERS
/// ══════════════════════════════════════════════════════════
///
/// Mobile:   < 600
/// Tablet:   600 – 1023
/// Desktop:  >= 1024

/// Minimum size below which the app should not compress further.
/// The content area will scroll if the viewport is smaller.
class AppConstraints {
  AppConstraints._();

  static const double minWidth = 360;
  static const double minHeight = 480;
  static const double minAspectRatio = 9 / 21; // portrait phone extreme
  static const double maxAspectRatio = 21 / 9; // ultrawide

  static BoxConstraints get minimum =>
      const BoxConstraints(minWidth: minWidth, minHeight: minHeight);
}

enum ScreenSize { mobile, tablet, desktop }

class Breakpoints {
  Breakpoints._();

  static const double mobile = 600;
  static const double tablet = 1024;

  static ScreenSize of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < mobile) return ScreenSize.mobile;
    if (width < tablet) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= mobile && w < tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;

  /// True for tablet + desktop (wide enough for side-by-side layouts).
  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mobile;
}

/// Extension on BuildContext for quick access.
extension ResponsiveContext on BuildContext {
  ScreenSize get screenSize => Breakpoints.of(this);
  bool get isMobile => Breakpoints.isMobile(this);
  bool get isTablet => Breakpoints.isTablet(this);
  bool get isDesktop => Breakpoints.isDesktop(this);
  bool get isWide => Breakpoints.isWide(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
}

/// Wraps a child with minimum size constraints.
/// On small viewports the content becomes scrollable in both axes.
class MinSizeContainer extends StatelessWidget {
  final Widget child;

  const MinSizeContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final needsHorizontalScroll = size.width < AppConstraints.minWidth;
    final needsVerticalScroll = size.height < AppConstraints.minHeight;

    if (!needsHorizontalScroll && !needsVerticalScroll) {
      return child;
    }

    Widget content = child;

    if (needsHorizontalScroll || needsVerticalScroll) {
      content = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: AppConstraints.minWidth,
              minHeight: AppConstraints.minHeight,
              maxWidth: needsHorizontalScroll
                  ? AppConstraints.minWidth
                  : size.width,
              maxHeight: needsVerticalScroll
                  ? AppConstraints.minHeight
                  : size.height,
            ),
            child: child,
          ),
        ),
      );
    }

    return content;
  }
}

/// Responsive padding: more on desktop, less on mobile.
class ResponsivePadding extends StatelessWidget {
  final Widget child;

  const ResponsivePadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final padding = switch (context.screenSize) {
      ScreenSize.mobile => const EdgeInsets.all(8),
      ScreenSize.tablet => const EdgeInsets.all(12),
      ScreenSize.desktop => const EdgeInsets.all(16),
    };

    return Padding(padding: padding, child: child);
  }
}
