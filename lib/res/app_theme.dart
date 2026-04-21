import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_sizes.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.lightSurface,
        background: AppColors.lightBackground,
        error: AppColors.error,
        brightness: Brightness.light,
      ),
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: AppColors.lightBackground,
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: AppSizes.fontXL,
          fontWeight: FontWeight.bold,
          color: AppColors.lightTextPrimary,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: AppSizes.fontL,
          fontWeight: FontWeight.bold,
          color: AppColors.lightTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: AppSizes.fontM,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: AppSizes.fontS,
          color: AppColors.lightTextSecondary,
        ),
      ),
      extensions: [
        AppCustomTheme(
          cardBg: AppColors.lightCardBg,
          borderColor: AppColors.lightBorder,
          textPrimary: AppColors.lightTextPrimary,
          textSecondary: AppColors.lightTextSecondary,
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkSurface,
        error: AppColors.error,
        brightness: Brightness.dark,
      ),
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: AppSizes.fontXL,
          fontWeight: FontWeight.bold,
          color: AppColors.darkTextPrimary,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: AppSizes.fontL,
          fontWeight: FontWeight.bold,
          color: AppColors.darkTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: AppSizes.fontM,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: AppSizes.fontS,
          color: AppColors.darkTextSecondary,
        ),
      ),
      extensions: [
        AppCustomTheme(
          cardBg: AppColors.darkCardBg,
          borderColor: AppColors.darkBorder,
          textPrimary: AppColors.darkTextPrimary,
          textSecondary: AppColors.darkTextSecondary,
        ),
      ],
    );
  }
}

class AppCustomTheme extends ThemeExtension<AppCustomTheme> {
  final Color? cardBg;
  final Color? borderColor;
  final Color? textPrimary;
  final Color? textSecondary;

  AppCustomTheme({
    this.cardBg,
    this.borderColor,
    this.textPrimary,
    this.textSecondary,
  });

  @override
  ThemeExtension<AppCustomTheme> copyWith({
    Color? cardBg,
    Color? borderColor,
    Color? textPrimary,
    Color? textSecondary,
  }) {
    return AppCustomTheme(
      cardBg: cardBg ?? this.cardBg,
      borderColor: borderColor ?? this.borderColor,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }

  @override
  ThemeExtension<AppCustomTheme> lerp(
    ThemeExtension<AppCustomTheme>? other,
    double t,
  ) {
    if (other is! AppCustomTheme) return this;
    return AppCustomTheme(
      cardBg: Color.lerp(cardBg, other.cardBg, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t),
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t),
    );
  }
}

extension AppThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get typography => theme.textTheme;
  AppCustomTheme get customTheme => theme.extension<AppCustomTheme>()!;
}
