import 'dart:html' as html;
import 'dart:async';

class WebNotificationService {
  static Future<void> requestPermission() async {
    if (!html.Notification.supported) return;
    if (html.Notification.permission != 'granted') {
      await html.Notification.requestPermission();
    }
  }

  static Future<void> show(String title, String body) async {
    if (!html.Notification.supported) return;

    if (html.Notification.permission != 'granted') {
      print("Permission not granted, cannot show notification");
      return;
    }

    html.Notification(title, body: body);
  }

  static void schedule(
    DateTime scheduledTime,
    String title,
    String body,
  ) async {
    if (!html.Notification.supported) return;

    if (html.Notification.permission != 'granted') {
      await requestPermission();
    }

    final now = DateTime.now();
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(Duration(days: 1));
    }

    final difference = scheduledTime.difference(now);
    print("Web notification scheduled in ${difference.inSeconds} seconds");

    Timer(difference, () {
      if (html.Notification.permission == 'granted') {
        html.Notification(title, body: body);
      } else {
        print("Permission not granted, notification skipped");
      }
    });
  }
}
