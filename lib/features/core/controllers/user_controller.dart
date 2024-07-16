import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:moodlet/features/core/screens/mood/mood.dart';
import '../../../data/services/notification_service.dart';
import 'settings_controllers/settings_controller.dart';
import '../screens/bottom_nav/navigation_menu.dart';
import '../screens/on_board/on_boarding.dart';
import '../../../utils/constants/local_storage_key.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/logging/logger.dart';
import '../../../utils/popups/popups.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  final _settings = SettingsController.instance;

  final usernameController = TextEditingController();
  String get userName => _localStorage.read(TLocalStorageKey.username);
  GlobalKey<FormState> userNameFormKey = GlobalKey<FormState>();

  final _localStorage = GetStorage();

  final _auth = LocalAuthentication();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  screenRedirect() async {
    final user = _localStorage.read(TLocalStorageKey.username);
    if (user == null || user == '') {
      await NotificationService.isNotificationAllowed();
      Get.offAll(() => const OnBoardingScreen());
    } else if (SettingsController.instance.togglePasscode.value) {
      await authenticateUser();
    } else {
      Get.offAll(() => const NavigationScreen());
    }
  }

  signup() async {
    try {
      if (!userNameFormKey.currentState!.validate()) return;

      _localStorage.write(TLocalStorageKey.username, usernameController.text);

      await Get.offAll(() => const MoodScreen(showBackArrow: false),
          transition: Transition.downToUp);
    } catch (e) {
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    }
  }

  changeUsername() {
    try {
      if (!userNameFormKey.currentState!.validate()) return;

      _localStorage.write(TLocalStorageKey.username, usernameController.text);

      Get.back();

      TPopup.successSnackbar(
          title: TTexts.success,
          message: 'New username set to ${usernameController.text}');
    } catch (e) {
      TPopup.errorSnackbar(
          title: TTexts.ohSnap,
          message: 'Something went wrong. Please try again');
    }
  }

  authenticateUser() async {
    await screenLock(
      context: Get.context!,
      correctString: _localStorage.read(TLocalStorageKey.passcode),
      canCancel: false,
      useBlur: false,
      customizedButtonChild: _settings.toggleFingerprint.value
          ? const Icon(Icons.fingerprint)
          : const SizedBox(),
      onOpened: () async =>
          _settings.toggleFingerprint.value ? await biometricAuth() : {},
      customizedButtonTap: () async {
        if (!_settings.toggleFingerprint.value) return;
        final auth = await biometricAuth();
        if (auth) {
          Get.offAll(() => const NavigationScreen());
        }
      },
      onUnlocked: () {
        Get.offAll(() => const NavigationScreen());
      },
    );
  }

  Future<bool> canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  Future<bool> biometricAuth() async {
    try {
      if (!await canAuthenticate()) return false;
      final didOpen = await _auth.authenticate(
        localizedReason: 'Unlock',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (didOpen) Get.offAll(() => const NavigationScreen());
      return didOpen;
    } catch (e) {
      return false;
    }
  }
}
