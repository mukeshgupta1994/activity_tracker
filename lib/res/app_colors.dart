import 'package:flutter/material.dart';

class AppColors {
  // ── Primary Brand ──────────────────────────────────────────
  static const Color primary = Color(0xFF3243E0); // royalBlue
  static const Color primaryLight = Color(0xFFEEF2FF); // light indigo tint
  static const Color primaryDark = Color(0xFF2A1FA3); // darker blue
  static const Color accent = Color(0xFFE8B84B); // golden accent (JLL gold)

  // ── Backgrounds ────────────────────────────────────────────
  static const Color lightLavender = Color(0xFFF5F6FC); // main bg
  static const Color lightBackground = Color(0xFFF5F6FC);
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color bgGray = Color(0xFFF5F6FC);

  // ── Surfaces (Cards, Panels) ───────────────────────────────
  static const Color lightSurface = Colors.white;
  static const Color darkSurface = Color(0xFF242424);
  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color colorDark = Color(0xFF1A1A1A);
  static const Color colorDarkLight = Color(0xFF242424);

  // ── Text ──────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF666666);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFA0AEC0);

  // ── Borders ───────────────────────────────────────────────
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color darkBorder = Color(0xFF393939);
  static const Color borderGrey = Color(0xFFBDBDBD);
  static const Color borderLightGrey = Color(0xFFE0E0E0);

  // ── Status Colors ─────────────────────────────────────────
  static const Color success = Color(0xFF059669);
  static const Color successBg = Color(0xFFECFDF5);
  static const Color error = Color(0xFFBE3730);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color warning = Color(0xFFD97706);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color info = Color(0xFF4394E5);

  static const Color approved = Color(0xFF059669);
  static const Color approvedBg = Color(0xFFECFDF5);
  static const Color pending = Color(0xFFD97706);
  static const Color pendingBg = Color(0xFFFFFBEB);
  static const Color rejected = Color(0xFFBE3730);
  static const Color rejectedBg = Color(0xFFFEF2F2);
  static const Color total = Color(0xFF3243E0);
  static const Color totalBg = Color(0xFFEEF2FF);

  // ── Misc ──────────────────────────────────────────────────
  static const Color colorBlack = Color(0xFF000000);
  static const Color colorGrey = Color(0xFF9E9E9E);
  static const Color lightGray = Color(0xFFD9D9D9);
  static const Color colorTransparent = Colors.transparent;
  static const Color colorRed = Color(0xFFBE3730);
  static const Color colorGreen = Color(0xFF007C36);

  // ── Resolution Portal specific ────────────────────────────
  static const Color royalBlue = Color(0xFF3243E0);
  static const Color softLilac = Color(0xFFDDCAE9);
  static const Color lightLavender1 = Color(0xFFF5F6FC);
  static const Color colorAccent = Color(0xFFE8B84B);
  static const Color colorPrimary = Color(0xFF3243E0);

  // ── Card Background ───────────────────────────────────────
  static const Color lightCardBg = Color(0xFFF8F9FE);
  static const Color darkCardBg = Color(0xFF1A1C28);

  // ── AppBar ────────────────────────────────────────────────
  static const Color lightAppBarBackground = Color(0xFFFFFFFF);
  static const Color lightAppBarBorder = Color(0xFFE0E0E0);
  static const Color darkAppBarBackground = Color(0xFF1A1A1A);
  static const Color darkAppBarBorder = Color(0xFF393939);

  // ── Shimmer ───────────────────────────────────────────────
  static const Color shimmerBaseLight = Color(0xFFD6D6D6);
  static const Color shimmerHighlightLight = Color(0xFFF0F0F0);
  static const Color shimmerBaseDark = Color(0xFF3A3A3A);
  static const Color shimmerHighlightDark = Color(0xFF4A4A4A);

  // ── Legacy aliases (backward compat) ──────────────────────
  static const Color secondary = Color(0xFF3243E0);
  static const Color colorDarkStroke = Color(0xFF393939);
  static const Color customBlue = Color(0xFF0065B2);

  // ── Legacy aliases for backward compatibility ──────────────
  /// Used in app_utils bottomSheetLoader text/icon color
  static const Color colorPrimaryGradientEnd = Color(0xFF2A1FA3);
  /// Amber/orange for pending or warning indicator
  static const Color colorOrange = Color(0xFFD97706);
  /// Soft golden-yellow background for selector cards
  static const Color colorYellow = Color(0xFFFFFBEB);
  /// Very light off-white background used in CutDivider notch
  static const Color backgroundLight = Color(0xFFF5F6FC);
}
