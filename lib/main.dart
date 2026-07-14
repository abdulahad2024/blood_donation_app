import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/data/firebase_notification/notification_service.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/constants/app_config.dart';
import 'app/utils/constants/app_themes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await NotificationService().initNotification();

  } catch (e) {
    debugPrint("Firebase Initialization Error: $e");
  }

  await initializeDateFormatting('bn');

  final prefs = await SharedPreferences.getInstance();
  bool savedIsDarkMode = prefs.getBool("isDarkMode") ?? false;

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConfig.appName,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: savedIsDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        AppThemes.setSystemBars(isDark: isDark);
        return child!;
      },
    ),
  );
}