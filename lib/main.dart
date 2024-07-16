import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'data/services/notification_service.dart';
import 'features/core/controllers/settings_controllers/settings_controller.dart';
import 'features/core/controllers/user_controller.dart';
import 'firebase_options.dart';
import 'moodlet.dart';

void main() async {
  // Ensure widgets binding
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Splash Screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize local storage
  await GetStorage.init();

  Get.put(SettingsController());

  await NotificationService.initializeNotification();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  Get.put(UserController());

  runApp(const Moodlet());
}
