import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/launcher_icon');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      /*  onDidReceiveLocalNotification: (
        int id,
        String? title,
        String? body,
        String? payload,
      ) async {}, */
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // await notificationsPlugin.initialize(
    //   initializationSettings,
    //   onDidReceiveNotificationResponse: (payload) async {},
    // );
  }

  static NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'low_importance_channel',
          'Local Notifications',
          channelDescription: 'This channel is used for local notifications.',
          importance: Importance.max,
        ),
        iOS: DarwinNotificationDetails(
          presentSound: true,
        ));
  }

  // static Future<void> showNotification({
  //   int id = 0,
  //   String? title,
  //   String? body,
  //   String? payLoad,
  // }) {
  //   return notificationsPlugin.show(
  //     id,
  //     title,
  //     body,
  //     notificationDetails(),
  //   );
  // }
}
