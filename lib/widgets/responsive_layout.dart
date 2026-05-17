import 'package:flutter/material.dart';

import '../views/desktop_view.dart';
import '../views/mobile_view.dart';

const double kResponsiveBreakpoint = 600;

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= kResponsiveBreakpoint) {
          return const DesktopView();
        }
        return const MobileView();
      },
    );
  }
}
