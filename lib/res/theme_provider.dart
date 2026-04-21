// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
//   final prefs = ref.watch(sharedPreferencesProvider);
//   return ThemeNotifier(prefs);
// });

// class ThemeNotifier extends StateNotifier<ThemeMode> {
//   final SharedPreferences _prefs;
//   static const _themeKey = 'theme_mode';

//   ThemeNotifier(this._prefs) : super(ThemeMode.system) {
//     _loadTheme();
//   }

//   void _loadTheme() {
//     final savedTheme = _prefs.getString(_themeKey);
//     if (savedTheme == 'light') {
//       state = ThemeMode.light;
//     } else if (savedTheme == 'dark') {
//       state = ThemeMode.dark;
//     } else {
//       state = ThemeMode.system;
//     }
//   }

//   void toggleTheme() {
//     if (state == ThemeMode.light) {
//       state = ThemeMode.dark;
//       _prefs.setString(_themeKey, 'dark');
//     } else {
//       state = ThemeMode.light;
//       _prefs.setString(_themeKey, 'light');
//     }
//   }

//   void setThemeMode(ThemeMode mode) {
//     state = mode;
//     _prefs.setString(_themeKey, mode.name);
//   }
// }
