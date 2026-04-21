import 'package:activity_tracker/data/local/db/themedata/db_client.dart';
import 'package:activity_tracker/data/remote/network/network_api_service.dart';
import 'package:activity_tracker/repository/api_repository.dart';
import 'package:activity_tracker/repository/db_repository.dart';
import 'package:activity_tracker/res/app_theme.dart';
import 'package:activity_tracker/utils/app_utils.dart';
import 'package:activity_tracker/utils/routes/app_routes.dart';
import 'package:activity_tracker/viewmodel/login_view_model.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:responsive_framework/responsive_framework.dart';

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
      builder: (context, child) {
        final MediaQueryData data = MediaQuery.of(context);
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
            child: kIsWeb
                ? Builder(
                    builder: (context) {
                      final width = ResponsiveValue<double>(
                        context,
                        defaultValue: 430.0, // Ensure default value is double
                        conditionalValues: conditionalWidthValues,
                      ).value; // Safe to unwrap since defaultValue is provided
                      return ResponsiveScaledBox(
                        width: width,
                        child: child ?? SizedBox.shrink(),
                      );
                    },
                  )
                : child ??
                 SizedBox.shrink(), breakpoints: [],
            // breakpoints: breakpoints,
          ),
        );
      },
      title: 'Activity Tracker',
      theme: AppTheme.lightTheme,
      routerConfig: goRouter,
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
