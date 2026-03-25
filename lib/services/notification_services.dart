import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:remindue/models/task.dart';
//import 'package:remindue/services/web_notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:remindue/ui/notified_page.dart';

import 'web_notification_stub.dart'
    if (dart.library.html) 'web_notification_service.dart';
import 'dart:async';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); //

  Future<void> InitializationNotification() async {
    _configureLocalTimezone();
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
        );

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("appicon");

    final InitializationSettings initializationSettings =
        InitializationSettings(
          iOS: initializationSettingsIOS,
          android: initializationSettingsAndroid,
        );
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        selectNotification(response.payload);
      },
    );
  }

  Future<void> scheduleNotification(int hour, int minute, Task task) async {
    //await Future.delayed(const Duration(seconds: 5));
    //int newTime = 5;
    if (kIsWeb) {
      // compute the scheduled DateTime
      final now = DateTime.now();
      DateTime scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // if time already passed today, schedule for tomorrow
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(Duration(days: 1));
      }

      final difference = scheduledTime.difference(now);
      print(
        "Web notification for '${task.title}' in ${difference.inSeconds} seconds",
      );

      // schedule notification
      Timer(difference, () {
        WebNotificationService.show(task.title ?? "Reminder", task.note ?? "");
      });
      return;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: task.id!.toInt(),
      title: task.title,
      body: task.note,
      scheduledDate: _convertTime(hour, minute),
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "${task.title}|${task.note}",
    );
  }

  tz.TZDateTime _convertTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  Future<void> displayNotification({
    required String title,
    required String body,
  }) async {
    print("doing test");

    if (kIsWeb) {
      await WebNotificationService.show(title, body);
      return;
    }

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: title,
    );
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }

    if (payload == 'Theme Changed') {
      print("Nothing to navigate");
      return;
    } else {
      //navigate to another screen
      Get.to(() => NotifiedPage(label: payload));
    }
  }

  Future onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    // display a dialog with the notification details, tap ok to go to another page
    /*      showDailog(
        //context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(body),
          action: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondScreen(payload),
                  ),
                );
              },
            )
          ],
        )
      ),
    );*/
    Get.dialog(Text("Welcome to flutter"));
  }
}
