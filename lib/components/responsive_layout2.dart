// import 'package:flutter/material.dart';
// import 'package:responsive_framework/responsive_framework.dart';

// class ResponsiveLayout2 extends StatelessWidget {
//   final Widget? mobile;
//   final Widget? tablet;
//   final Widget? desktop;
//   const ResponsiveLayout2(
//       {super.key,
//       required this.mobile,
//       required this.tablet,
//       required this.desktop});

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: ((context, constraints) {
//       if (ResponsiveBreakpoints.of(context).isMobile) {
//         return mobile ?? const SizedBox.shrink();
//       } else if (ResponsiveBreakpoints.of(context).isTablet) {
//         return tablet ?? const SizedBox.shrink();
//       } else if (ResponsiveBreakpoints.of(context).isDesktop) {
//         return desktop ?? const SizedBox.shrink();
//       }
//       return const SizedBox.shrink();
//     }));
//   }
// }
