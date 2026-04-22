/// Stub implementation of Push Notification Service
/// This is used on platforms (like web) that don't support Firebase
/// On native platforms, the real implementation is conditionally loaded
import 'package:flutter/foundation.dart';

class PushNotificationService {
  static Future<void> initialize() async {
    if (kDebugMode) {
      debugPrint('PushNotificationService: Skipped (web/unsupported platform)');
    }
  }

  static Future<String> getFcmId() async {
    return '';
  }

  static Future<void> deleteFcmId() async {
    if (kDebugMode) {
      debugPrint('PushNotificationService.deleteFcmId: No-op on web');
    }
  }

  static Future<void> requestNotificationPermission() async {
    if (kDebugMode) {
      debugPrint(
        'PushNotificationService.requestNotificationPermission: No-op on web',
      );
    }
  }

  static Future<void> setupInteractedMessage() async {
    if (kDebugMode) {
      debugPrint(
        'PushNotificationService.setupInteractedMessage: No-op on web',
      );
    }
  }

  static Future<void> setupForegroundNotification() async {
    if (kDebugMode) {
      debugPrint(
        'PushNotificationService.setupForegroundNotification: No-op on web',
      );
    }
  }
}
