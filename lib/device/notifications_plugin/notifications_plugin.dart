import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notifcationPluginProvider = Provider<NotificationsPlugin>((ref) {
  return NotificationsPlugin();
});

class NotificationsPlugin {
/*
 * Singleton Pattern 
 */
  static final NotificationsPlugin _notificationPlugin =
      NotificationsPlugin._internal();

  factory NotificationsPlugin() {
    return _notificationPlugin;
  }

  NotificationsPlugin._internal();

  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  ///Initialise the notification plugin
  Future<void> initialisePlugin() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('codex_logo');
    final initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: iosOnDidReceiveNotification);
    const initializationSettingsMacOS = MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future<void> iosOnDidReceiveNotification(
      int id, String? title, String? body, String? payload) async {}

  Future<void> selectNotification(String? payload) async {
    payload != null ? log('android notification payload: $payload') : null;
  }

  Future<void> scheduleNotificationTest() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Australia/Sydney'));

    const androidNotificaitonDetails = AndroidNotificationDetails(
      'pet_gps_tracker',
      'Tarzan\'s GPS Tracker',
      'Test notification for the tracker',
    );

    const iosNotificationDetails = IOSNotificationDetails();

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Tarzan GPS Tracker',
        'Tarzan is outside of your geofence!',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 3)),
        const NotificationDetails(
          android: androidNotificaitonDetails,
          iOS: iosNotificationDetails,
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
