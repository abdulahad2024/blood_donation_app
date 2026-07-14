import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationDbService {
  static const String _storageKey = 'local_notifications_list';

  static Future<void> saveNotificationToLocal(RemoteMessage message) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String title = message.notification?.title ?? "নোটিফিকেশন";
      String body = message.notification?.body ?? "";
      String time = DateTime.now().toString();

      String imageUrl = message.notification?.android?.imageUrl ?? message.data['image'] ?? "";

      Map<String, String> newNotification = {
        'title': title,
        'body': body,
        'time': time,
        'image_url': imageUrl,
      };

      List<String> currentSavedList = prefs.getStringList(_storageKey) ?? [];
      currentSavedList.insert(0, json.encode(newNotification));
      await prefs.setStringList(_storageKey, currentSavedList);
    } catch (e) {
      print("Error saving notification locally: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> getLocalNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList(_storageKey) ?? [];
    return savedList.map((item) => json.decode(item) as Map<String, dynamic>).toList();
  }

  static Future<void> clearNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}