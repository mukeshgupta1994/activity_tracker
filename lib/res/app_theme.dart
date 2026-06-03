import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.royalBlue,
      colorScheme: const ColorScheme.light(
        primary: AppColors.royalBlue,
        secondary: AppColors.colorAccent,
        surface: AppColors.lightSurface,
        error: AppColors.error,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.lightLavender,
      cardColor: AppColors.colorWhite,
      textTheme: GoogleFonts.poppinsTextTheme(
        _textTheme(AppColors.textPrimary),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 0.5,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.colorWhite,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.colorWhite,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.lightBorder.withOpacity(0.5)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderLightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderLightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.royalBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.colorRed),
        ),
        filled: true,
        fillColor: AppColors.colorWhite,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w400,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.royalBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          elevation: 0,
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.royalBlue,
          side: const BorderSide(color: AppColors.royalBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      extensions: [
        AppCustomTheme(
          cardBg: AppColors.colorWhite,
          borderColor: AppColors.lightBorder,
          textPrimary: AppColors.textPrimary,
          textSecondary: AppColors.textSecondary,
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.royalBlue,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.royalBlue,
        secondary: AppColors.colorAccent,
        surface: AppColors.darkSurface,
        error: AppColors.error,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkSurface,
      textTheme: GoogleFonts.poppinsTextTheme(
        _textTheme(AppColors.darkTextPrimary),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 0.5,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.darkTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.royalBlue, width: 1.5),
        ),
        filled: true,
        fillColor: AppColors.darkSurface,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.darkTextSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.royalBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          elevation: 0,
        ),
      ),
      extensions: [
        AppCustomTheme(
          cardBg: AppColors.darkSurface,
          borderColor: AppColors.darkBorder,
          textPrimary: AppColors.darkTextPrimary,
          textSecondary: AppColors.darkTextSecondary,
        ),
      ],
    );
  }

  static TextTheme _textTheme(Color textColor) => TextTheme(
    bodyLarge: TextStyle(fontSize: 14, color: textColor),
    bodyMedium: TextStyle(fontSize: 13, color: textColor),
    bodySmall: TextStyle(fontSize: 11, color: textColor),
    displayLarge: TextStyle(fontSize: 16, color: textColor),
    displayMedium: TextStyle(fontSize: 15, color: textColor),
    displaySmall: TextStyle(fontSize: 13, color: textColor),
    headlineSmall: TextStyle(fontSize: 13, color: textColor),
    headlineMedium: TextStyle(fontSize: 14, color: textColor),
    headlineLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: textColor,
    ),
    titleLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: textColor,
    ),
    titleMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: textColor,
    ),
    titleSmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: textColor,
    ),
    labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
    labelSmall: TextStyle(fontSize: 10, color: textColor),
    labelMedium: TextStyle(fontSize: 11, color: textColor),
  );

  static BoxDecoration getBoxDecoration(
    BuildContext context, {
    BorderRadius? borderRadius,
  }) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDarkMode ? AppColors.darkSurface : AppColors.colorWhite,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
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
