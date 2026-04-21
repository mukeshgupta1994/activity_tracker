import 'dart:io';
import 'package:activity_tracker/data/local/db/themedata/db_client.dart';
import 'package:activity_tracker/data/local/db/themedata/hive_init.dart'
    as hive_init;
import 'package:activity_tracker/data/remote/network/base_api_service.dart';
import 'package:activity_tracker/data/remote/network/network_api_service.dart';
import 'package:activity_tracker/repository/api_repository.dart';
import 'package:activity_tracker/repository/db_repository.dart';
import 'package:activity_tracker/res/app_theme.dart';
import 'package:activity_tracker/services/notification/notification_service.dart';
import 'package:activity_tracker/utils/app_utils.dart';
import 'package:activity_tracker/utils/routes/app_routes.dart';
import 'package:activity_tracker/view/firebase_option.dart';
import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
import 'package:activity_tracker/viewmodel/login_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:go_router/go_router.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();
  // Initialize Firebase defensively: DefaultFirebaseOptions may not be
  // generated/configured for every platform (macOS in this workspace), and
  // DefaultFirebaseOptions.currentPlatform throws when not configured.
  FirebaseOptions? firebaseOptions;
  try {
    // Attempt to read generated options (this may throw if not present)
    firebaseOptions = DefaultFirebaseOptions.currentPlatform;
  } catch (e) {
    debugPrint(
      'Firebase DefaultFirebaseOptions not configured for this platform: $e',
    );
  }

  try {
    if (firebaseOptions != null) {
      await Firebase.initializeApp(options: firebaseOptions);
    } else {
      // Try default initialization (may work if native plist/json is present),
      // otherwise continue without Firebase initialized.
      await Firebase.initializeApp();
    }
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    // If Firebase can't be initialized, log and continue so the app can run
    // locally without Firebase. This is a non-invasive fallback to unblock
    // development; proper fix is to configure FlutterFire for macOS.
    debugPrint('Firebase initialization failed or skipped: $e');
  }
  await NotificationService.initNotification();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  await hive_init.hiveInit();

  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dbRepo = DbRepository(DbClient());
    final httpClient = http.Client();
    final apiService = NetworkApiService(dbRepo, httpClient);
    final apiRepo = ApiRepository(apiService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
      create: (_) => ActivityDashViewModel(
        dbRepository: dbRepo,
        apiRepository: apiRepo,
      ),
    ),
        ChangeNotifierProvider(
          create: (_) =>
              LoginViewModel(apiRepository: apiRepo, dbRepository: dbRepo),
        ),
      ],
      child: const AppMaterial(),
    );
  }
}

class AppMaterial extends StatelessWidget {
  const AppMaterial({super.key});

  // Your exact breakpoints + conditionalWidthValues (same as you sent)
  static const breakpoints = [
    Breakpoint(start: 0, end: 450, name: MOBILE),
    Breakpoint(start: 451, end: 800, name: TABLET),
    Breakpoint(start: 801, end: 1920, name: DESKTOP),
    Breakpoint(start: 1921, end: double.infinity, name: '4K'),
  ];

  static const conditionalWidthValues = [
    Condition.equals(name: MOBILE, value: 450.0),
    Condition.between(start: 500, end: 799, value: 800.0),
    Condition.between(start: 800, end: 999, value: 950.0),
    Condition.between(start: 1000, end: 1199, value: 1100.0),
    Condition.between(start: 1200, end: 1399, value: 1300.0),
    Condition.between(start: 1400, end: 2000, value: 1500.0),
  ];

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) AppUtils.systemOverUILayStyle(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Activity Tracker',
      theme: AppTheme.lightTheme,
      routerConfig: goRouter, // From app_routes.dart
      builder: (context, child) {
        final data = MediaQuery.of(context);
        final textScaler = data.textScaler.clamp(
          minScaleFactor: 1.0,
          maxScaleFactor: 1.0,
        );

        return MediaQuery(
          data: data.copyWith(
            textScaler: textScaler,
            alwaysUse24HourFormat: false,
          ),
          child: ResponsiveBreakpoints.builder(
            breakpoints: breakpoints,
            child: kIsWeb
                ? Builder(
                    builder: (context) {
                      final width = ResponsiveValue<double>(
                        context,
                        defaultValue: 430.0,
                        conditionalValues: conditionalWidthValues,
                      ).value;
                      return ResponsiveScaledBox(
                        width: width,
                        child: child ?? const SizedBox.shrink(),
                      );
                    },
                  )
                : child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
