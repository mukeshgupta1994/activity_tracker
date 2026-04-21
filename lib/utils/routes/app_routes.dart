import 'package:activity_tracker/data/local/hive_helper.dart';
import 'package:activity_tracker/view/login%20screen/send_otp.dart';
import 'package:activity_tracker/view/login%20screen/verify_otp.dart';
import 'package:activity_tracker/view/splash%20screen/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static String splashScreenRoute = '/';
  static String loginScreenRoute = '/login';
  static String verifyOtpScreenRoute = '/authenticate';
  static String activitytrackerdashboard = '/activity-tracker-dashboard';
  static String editActivityScreen = '/Edit-Activity-Screen';


  
}

final goRouter = GoRouter(
  initialLocation: AppRoutes.splashScreenRoute,
  redirect: (context, state) {
    final location = state.matchedLocation;
    if (!HiveHelper.isLoggedIn) {
      if (location == AppRoutes.editActivityScreen ||
          ![
            AppRoutes.splashScreenRoute,
            AppRoutes.loginScreenRoute,
            AppRoutes.verifyOtpScreenRoute,
          ].contains(location)) {
        return AppRoutes.loginScreenRoute;
      }
    } else {
      if (location == AppRoutes.loginScreenRoute ||
          location == AppRoutes.verifyOtpScreenRoute) {
        return AppRoutes.editActivityScreen;
      }
    }
    return null;
  },
  /* errorBuilder: (context, state) {
    if (HiveHelper.isLoggedIn) {
      return const HomePage();
    } else {
      return const SendOtpScreen();
    }
  }, */
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
  ],
);