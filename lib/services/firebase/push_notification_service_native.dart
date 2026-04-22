// import 'dart:convert';
// import 'package:activity_tracker/services/firebase/notifications_bloc.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// /// Native implementation of PushNotificationService (for iOS, Android)
// class PushNotificationService {
//   static Future<void> setupInteractedMessage() async {
//     await Firebase.initializeApp();

//     RemoteMessage? initialMessage = await FirebaseMessaging.instance
//         .getInitialMessage();

//     if (initialMessage != null) {
//       _performActionOnNotification(initialMessage.data);
//     }

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint('${message.data}');
//       _performActionOnNotification(message.data);
//     });
//     await enableIOSNotifications();
//     await registerNotificationListeners();
//     String? fcmId = await getFcmId();
//     debugPrint('FCM ID : $fcmId');
//     FirebaseMessaging.instance.onTokenRefresh.listen(
//       (token) => debugPrint('FCM ID refreshed: $token'),
//     );
//   }

//   static Future<String> getFcmId() async {
//     try {
//       return await FirebaseMessaging.instance.getToken() ?? '';
//     } catch (e) {
//       return '';
//     }
//   }

//   static Future<void> deleteFcmId() async =>
//       FirebaseMessaging.instance.deleteToken();

//   static Future<void> registerNotificationListeners() async {
//     AndroidNotificationChannel channel = androidNotificationChannel();
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);
//     var androidSettings = const AndroidInitializationSettings(
//       '@mipmap/launcher_icon',
//     );
//     var iOSSettings = const DarwinInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//     );
//     var initSetttings = InitializationSettings(
//       android: androidSettings,
//       iOS: iOSSettings,
//     );
//     // flutterLocalNotificationsPlugin.initialize(initSetttings,
//     //     onDidReceiveNotificationResponse: (response) async {
//     //   final data = jsonDecode(response.payload ?? "");
//     //   debugPrint('$data');
//     //   _performActionOnNotification(data as Map<String, dynamic>);
//     // });

//     FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
//       debugPrint('${message?.data}');
//       RemoteNotification? notification = message!.notification;
//       AndroidNotification? android = message.notification?.android;

//       if (notification != null && android != null) {
//         // flutterLocalNotificationsPlugin.show(
//         //     notification.hashCode,
//         //     notification.title,
//         //     notification.body,
//         //     NotificationDetails(
//         //       android: AndroidNotificationDetails(
//         //         channel.id,
//         //         channel.name,
//         //         channelDescription: channel.description,
//         //         icon: android.smallIcon,
//         //         playSound: true,
//         //       ),
//         //     ),
//         //     payload: jsonEncode(message.data));
//       }
//     });
//   }

//   static void _performActionOnNotification(Map<String, dynamic> message) {
//     NotificationsBloc.instance.newNotification(message);
//   }

//   static Future<void> enableIOSNotifications() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//           alert: true, // Required to display a heads up notification
//           badge: true,
//           sound: true,
//         );
//   }

//   static AndroidNotificationChannel androidNotificationChannel() =>
//       const AndroidNotificationChannel(
//         'high_importance_channel', // id
//         'High Importance Notifications', // title
//         description:
//             'This channel is used for important notifications.', // description
//         importance: Importance.max,
//       );
// }
