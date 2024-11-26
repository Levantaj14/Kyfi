import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class Notifications {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static NotificationDetails _notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  static Future init({bool initSchedule = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);
    if (initSchedule) {
      tz.initializeTimeZones();
      final locationName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
    await _notifications.initialize(settings);
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    _notifications.show(id, title, body, _notificationDetails());
  }

  static Future showScheduleNotification(
          {int id = 1,
          String? title,
          String? body,
          required TimeOfDay scheduledDate}) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          _scheduleDaily(TimeOfDay(
              hour: scheduledDate.hour, minute: scheduledDate.minute)),
          _notificationDetails(),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);

  static tz.TZDateTime _scheduleDaily(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute, 0);
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }
}

class TurnScheduleOn {
  static Future scheduleNotification() async {
    List<String> titleRND = [
      "Kop kop 👀",
      "Hahoooo 😁",
      "Mit tervezel most csinálni? 🤨",
      "Haloooo 👋",
      "Szérusz 😑"
    ];

    List<String> bodyRND = [
      "Itt az idő az újabb napi igéhez",
      "Ne felejtsd! Napi ige time van",
      "Itt az idő, kezd MOST olvasni az igét",
      "Tudod te is, hogy mit kell tenned",
      "Tán nem akarod skippelni a mai napi igét?"
    ];

    var random = Random();
    final prefs = await SharedPreferences.getInstance();
    bool bekapcs = prefs.getBool("NotificationOn") ?? false;
    int aux = prefs.getInt("NotificationTime") ?? 840;
    TimeOfDay timeOfDay = TimeOfDay(hour: aux ~/ 60, minute: aux % 60);
    if (bekapcs) {
      Notifications.showScheduleNotification(
          title: titleRND[random.nextInt(4)],
          body: bodyRND[random.nextInt(4)],
          scheduledDate: timeOfDay);
    }
  }

  static Future initialNotification() async {
    Notifications.showNotification(
        title: "Juhuuu 🥳", body: "Sikeresen bekapcsoltad az értesítéseket");
  }
}
