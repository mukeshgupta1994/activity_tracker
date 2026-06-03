import 'package:activity_tracker/data/local/hive_helper.dart';
import 'package:activity_tracker/view/homescreen/home_screen.dart';
import 'package:activity_tracker/view/homescreen/widget/activity_screen.dart';
import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
import 'package:activity_tracker/view/login%20screen/send_otp.dart';
import 'package:activity_tracker/view/login%20screen/verify_otp.dart';
import 'package:activity_tracker/view/splash%20screen/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const splashScreenRoute = '/';
  static const loginScreenRoute = '/login';
  static const verifyOtpScreenRoute = '/authenticate';
  static const activitytrackerdashboard = '/dashboard';
  static const editActivityScreen = '/edit-activity';
}

final goRouter = GoRouter(
  initialLocation: AppRoutes.splashScreenRoute,
  redirect: (context, state) {
    final location = state.matchedLocation;

    // Splash — no redirect
    if (location == AppRoutes.splashScreenRoute) return null;

    final loggedIn = HiveHelper.isLoggedIn;

    // Sirf dashboard protected hai
    if (!loggedIn && location == AppRoutes.activitytrackerdashboard) {
      return AppRoutes.loginScreenRoute;
    }

    // Login/OTP pe already logged in → dashboard
    if (loggedIn &&
        (location == AppRoutes.loginScreenRoute ||
            location == AppRoutes.verifyOtpScreenRoute)) {
      return AppRoutes.activitytrackerdashboard;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splashScreenRoute,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.loginScreenRoute,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: SendOtpScreen()),
    ),
    GoRoute(
      path: AppRoutes.verifyOtpScreenRoute,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: VerifyOtpScreen()),
    ),
    GoRoute(
      path: AppRoutes.activitytrackerdashboard,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: ActivityTrackerDashboard()),
    ),
    GoRoute(
      path: AppRoutes.editActivityScreen,
      pageBuilder: (context, state) => NoTransitionPage(
        child: EditActivityScreen(vm: Provider.of<ActivityDashViewModel>(context, listen: false), onBack: () {  },)
        // Builder(
        //   builder: (ctx) => EditActivityScreen(
        //     vm: ctx.read<ActivityDashViewModel>(),
        //   ),
        // ),
      ),
    ),
  ],
);

// import 'package:activity_tracker/data/local/hive_helper.dart';
// import 'package:activity_tracker/view/homescreen/home_screen.dart';
// import 'package:activity_tracker/view/homescreen/widget/activity_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
// import 'package:activity_tracker/view/login%20screen/send_otp.dart';
// import 'package:activity_tracker/view/login%20screen/verify_otp.dart';
// import 'package:activity_tracker/view/splash%20screen/splash_screen.dart';
// import 'package:go_router/go_router.dart';

// class AppRoutes {
//   static String splashScreenRoute = '/';
//   static String loginScreenRoute = '/login';
//   static String verifyOtpScreenRoute = '/authenticate';
//   static const activitytrackerdashboard = '/dashboard';
//   static const editActivityScreen = '/edit-activity';
// }

// // ── Routes that are accessible WITHOUT login ──────────────────────────────────
// final _publicRoutes = [
//   AppRoutes.splashScreenRoute,
//   AppRoutes.loginScreenRoute,
//   AppRoutes.verifyOtpScreenRoute,
// ];

// // ── Routes that require login ─────────────────────────────────────────────────
// // (anything NOT in _publicRoutes is treated as protected)

// final goRouter = GoRouter(
//   initialLocation: AppRoutes.splashScreenRoute,
//   redirect: (context, state) {
//     final location = state.matchedLocation;
//     final loggedIn = HiveHelper.isLoggedIn;

//     // 1️⃣  Not logged in → redirect to login UNLESS already on a public route
//     if (!loggedIn && !_publicRoutes.contains(location)) {
//       return AppRoutes.loginScreenRoute;
//     }

//     // 2️⃣  Already logged in → don't let them land on login/otp screens again
//     if (loggedIn &&
//         (location == AppRoutes.loginScreenRoute ||
//             location == AppRoutes.verifyOtpScreenRoute)) {
//       return AppRoutes.activitytrackerdashboard;
//     }

//     return null; // no redirect needed
//   },
//   routes: [
//     GoRoute(
//       path: AppRoutes.splashScreenRoute,
//       builder: (context, state) => const SplashScreen(),
//     ),
//     GoRoute(
//       path: AppRoutes.loginScreenRoute,
//       pageBuilder: (context, state) =>
//           const NoTransitionPage(child: SendOtpScreen()),
//     ),
//     GoRoute(
//       path: AppRoutes.verifyOtpScreenRoute,
//       pageBuilder: (context, state) =>
//           const NoTransitionPage(child: VerifyOtpScreen()),
//     ),
//     GoRoute(
//       path: AppRoutes.activitytrackerdashboard,
//       pageBuilder: (context, state) =>
//           const NoTransitionPage(child: ActivityTrackerDashboard()),
//     ),
//     GoRoute(
//       path: AppRoutes.editActivityScreen,
//       pageBuilder: (context, state) => NoTransitionPage(
//         child: Builder(
//           builder: (ctx) => EditActivityScreen(
//             vm: ctx
//                 .read<
//                   ActivityDashViewModel
//                 >(), // ← yeh context MaterialApp ka hai
//           ),
//         ),
//       ),
//     ),
//   ],
// );

// // import 'package:activity_tracker/data/local/hive_helper.dart';
// // import 'package:activity_tracker/view/homescreen/home_screen.dart';
// // import 'package:activity_tracker/view/homescreen/widget/activity_screen.dart';
// // import 'package:provider/provider.dart';
// // import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
// // import 'package:activity_tracker/view/login%20screen/send_otp.dart';
// // import 'package:activity_tracker/view/login%20screen/verify_otp.dart';
// // import 'package:activity_tracker/view/splash%20screen/splash_screen.dart';
// // import 'package:go_router/go_router.dart';

// // class AppRoutes {
// //   static String splashScreenRoute = '/';
// //   static String loginScreenRoute = '/login';
// //   static String verifyOtpScreenRoute = '/authenticate';
// //   static const activitytrackerdashboard = '/dashboard';
// // static const editActivityScreen = '/edit-activity';
// //   // static String activitytrackerdashboard = '/activity-tracker-dashboard';
// //   // static String editActivityScreen = '/Edit-Activity-Screen';
// // }

// // final goRouter = GoRouter(
// //   initialLocation: AppRoutes.splashScreenRoute,
// //   redirect: (context, state) {
// //     final location = state.matchedLocation;
// //     if (!HiveHelper.isLoggedIn) {
// //   if (location == AppRoutes.activitytrackerdashboard ||
// //       ![
// //         AppRoutes.splashScreenRoute,
// //         AppRoutes.loginScreenRoute,
// //         AppRoutes.verifyOtpScreenRoute,
// //         AppRoutes.editActivityScreen,
// //       ].contains(location)) {
// //     return AppRoutes.loginScreenRoute;
// //   }
// // }
// //     // if (!HiveHelper.isLoggedIn) {
// //     //   if (location == AppRoutes.activitytrackerdashboard ||
// //     //       ![
// //     //         AppRoutes.splashScreenRoute,
// //     //         AppRoutes.loginScreenRoute,
// //     //         AppRoutes.verifyOtpScreenRoute,
// //     //       ].contains(location)) {
// //     //     return AppRoutes.loginScreenRoute;
// //     //   }
// //     // }
// //      else {
// //       if (location == AppRoutes.loginScreenRoute ||
// //           location == AppRoutes.verifyOtpScreenRoute) {
// //         return AppRoutes.activitytrackerdashboard;
// //         //AppRoutes.editActivityScreen;
// //       }
// //     }
// //     return null;
// //   },
// //   /* errorBuilder: (context, state) {
// //     if (HiveHelper.isLoggedIn) {
// //       return const HomePage();
// //     } else {
// //       return const SendOtpScreen();
// //     }
// //   }, */
// //   routes: [
// //     GoRoute(
// //       path: AppRoutes.splashScreenRoute,
// //       builder: (context, state) => const SplashScreen(),
// //     ),
// //     GoRoute(
// //       path: AppRoutes.loginScreenRoute,
// //       pageBuilder: (context, state) =>
// //           const NoTransitionPage(child: SendOtpScreen()),
// //     ),
// //     GoRoute(
// //       path: AppRoutes.verifyOtpScreenRoute,
// //       pageBuilder: (context, state) =>
// //           const NoTransitionPage(child: VerifyOtpScreen()),
// //     ),
// //     GoRoute(
// //       path: AppRoutes.activitytrackerdashboard,
// //       pageBuilder: (context, state) =>
// //           const NoTransitionPage(child: ActivityTrackerDashboard()),
// //     ),
// //     GoRoute(
// //       path: AppRoutes.editActivityScreen,
// //       pageBuilder: (context, state) => NoTransitionPage(
// //         child: EditActivityScreen(
// //           vm: Provider.of<ActivityDashViewModel>(context, listen: false),
// //         ),
// //       ),
// //     ),
// //   ],
// // );
