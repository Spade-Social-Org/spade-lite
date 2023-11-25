import 'notifs_channel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifHandler {
  static Future<void> handleNotifMessage(RemoteMessage message) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            enableVibration: true,
            icon: 'app_icon',
            importance: Importance.max,
            playSound: true,
            priority: Priority.max,

            channelDescription: channel.description,
            //icon: android?.smallIcon,
            // other properties...
          ),
        ),
      );
    }
  }

  static Future<void> refreshTokens() async {
    FirebaseMessaging.instance.setAutoInitEnabled(true);

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    String? token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, notifDetails) =>
                flutterLocalNotificationsPlugin.show(
                  id,
                  title,
                  body,
                  NotificationDetails(
                    iOS: const DarwinNotificationDetails(
                      presentAlert: true,
                      presentBadge: true,
                      presentSound: true,
                    ),
                    android: AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      enableVibration: true,
                      icon: 'app_icon',
                      importance: Importance.max,
                      playSound: true,
                      priority: Priority.max,

                      channelDescription: channel.description,
                      //icon: android?.smallIcon,
                      // other properties...
                    ),
                  ),
                ));

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
          critical: true,
        );

    FirebaseMessaging.onMessageOpenedApp
        .listen(NotifHandler.handleNotifMessage);

    FirebaseMessaging.onMessage.listen(NotifHandler.handleNotifMessage);
    FirebaseMessaging.onBackgroundMessage(handleNotifMessage);
  }
}

Future<void> handleNotifMessage(RemoteMessage message) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  // If `onMessage` is triggered with a notification, construct our own
  // local notification to show to users using the created channel.
  if (notification != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          enableVibration: true,
          icon: 'app_icon',
          importance: Importance.max,
          playSound: true,
          priority: Priority.max,
          channelDescription: channel.description,
          //icon: android?.smallIcon,
          // other properties...
        ),
      ),
    );
  }
}
