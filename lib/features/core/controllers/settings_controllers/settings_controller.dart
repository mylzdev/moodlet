import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../data/services/notification_service.dart';
import '../../models/mood_model/mood_choice_model.dart';
import '../../../../utils/constants/local_storage_key.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/popups/popups.dart';
import 'package:share_plus/share_plus.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

  // Local Storage
  final _localStorage = GetStorage();

  // Daily reminder rx variables
  final dailyReminderSwitch = false.obs;
  Rx<TimeOfDay?> dailyTime = Rx<TimeOfDay?>(null);

  // Display Mode rx variables
  final tempDisplayIndex = 0.obs;
  final selectedDisplayModeIndex = 0.obs;

  // Passcode Lock rx variables
  final togglePasscode = false.obs;
  final toggleFingerprint = false.obs;

  // Emoticons rx variables
  final selectedEmoticons = 0.obs;

  @override
  void onInit() async {
    setPasscode();
    setFirstDate();
    setDailyTime();
    setIsDailyReminder();
    readThemeModeLocally();
    readCurrentEmoticons();
    super.onInit();
  }

  // Set first day of installation
  void setFirstDate() async {
    await _localStorage.writeIfNull(
        TLocalStorageKey.firstDay, DateTime.now().toIso8601String());
  }
  // Daily Reminder methos

  void setDailyTime() {
    final savedTime =
        _localStorage.read<Map<String, dynamic>>(TLocalStorageKey.dailyTime);
    if (savedTime != null) {
      dailyTime.value = TimeOfDay(
        hour: savedTime['hour'],
        minute: savedTime['minute'],
      );
    }
  }

  void setIsDailyReminder() async {
    await _localStorage.writeIfNull(TLocalStorageKey.isDailyReminder, false);
    final isDailyReminder =
        _localStorage.read(TLocalStorageKey.isDailyReminder);
    dailyReminderSwitch.value = isDailyReminder;
  }

  void setPasscode() {
    _localStorage.writeIfNull(TLocalStorageKey.toggleFingerprint, false);
    _localStorage.writeIfNull(TLocalStorageKey.togglePasscode, false);

    final isFingerprintEnable =
        _localStorage.read(TLocalStorageKey.toggleFingerprint);
    final isPasscodeEnable =
        _localStorage.read(TLocalStorageKey.togglePasscode);

    togglePasscode.value = isPasscodeEnable;
    toggleFingerprint.value = isFingerprintEnable;
  }

  Future<void> showTimePicker() async {
    TimeOfDay? pickedTime = await THelperFunctions.toggleClockPicker();
    if (pickedTime != null) {
      dailyTime.value = pickedTime;
      await _localStorage.write(
        TLocalStorageKey.dailyTime,
        {'hour': pickedTime.hour, 'minute': pickedTime.minute},
      );
    }

    if (pickedTime != null && dailyReminderSwitch.value) {
      // NotificationService.cancelScheduleNotification();
      NotificationService.createDailyReminderNotification();
      TPopup.successSnackbar(
          title: TTexts.success, message: 'Daily reminder updated');
    }
  }

  void toggleDailyReminder(bool toggle) async {
    if (dailyTime.value == null) {
      await showTimePicker();
    }

    if (dailyTime.value != null) {
      dailyReminderSwitch.value = toggle;
      await _localStorage.write(
          TLocalStorageKey.isDailyReminder, dailyReminderSwitch.value);
      if (dailyReminderSwitch.value) {
        NotificationService.createDailyReminderNotification();
      } else {
        NotificationService.cancelScheduleNotification(
            NotificationService.dailyChannel);
      }
    }
  }

  // Display mode methods
  void readThemeModeLocally() async {
    await _localStorage.writeIfNull(
        TLocalStorageKey.displayMode, selectedDisplayModeIndex.value);
    final themeMode = _localStorage.read(TLocalStorageKey.displayMode);
    tempDisplayIndex.value = themeMode;

    if (themeMode == 0) {
      selectedDisplayModeIndex.value = 0;
    } else if (themeMode == 1) {
      selectedDisplayModeIndex.value = 1;
    } else {
      selectedDisplayModeIndex.value = 2;
    }
  }

  ThemeMode setThemeMode() {
    if (selectedDisplayModeIndex.value == 0) {
      return ThemeMode.system;
    } else if (selectedDisplayModeIndex.value == 1) {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark;
    }
  }

  void setSelectedDisplayModeIndex() async {
    if (tempDisplayIndex.value != selectedDisplayModeIndex.value) {
      selectedDisplayModeIndex.value = tempDisplayIndex.value;
      await _localStorage.write(
          TLocalStorageKey.displayMode, selectedDisplayModeIndex.value);
    }
  }

  // Toggle passcode
  void enablePasscode(bool toggle, BuildContext context) async {
    togglePasscode.value = toggle;
    _localStorage.write(TLocalStorageKey.togglePasscode, togglePasscode.value);
    if (togglePasscode.value) {
      // Create new passcode
      await screenLockCreate(
        context: context,
        useLandscape: false,
        title: Text('Enter new 4 digit passcode',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .apply(fontSizeFactor: 1.1, color: Colors.white)),
        onConfirmed: (value) {
          Navigator.pop(Get.overlayContext!);
          _localStorage.write(TLocalStorageKey.passcode, value);
          TPopup.successSnackbar(
              title: TTexts.success, message: 'New passcode has been saved');
        },
      );
    }
  }

  // Toggle Fingerprint
  void enableFingerprint(bool toggle) async {
    toggleFingerprint.value = toggle;
    _localStorage.write(
        TLocalStorageKey.toggleFingerprint, toggleFingerprint.value);
  }

  // Share with Friends
  Future<void> shareWithFriends() async {
    final result = await Share.share(
        "Track your mood effortlessly with this great app. It only takes a minute to keep a diary. Get it now.",
        subject: 'Hi there!');

    if (result.status == ShareResultStatus.success) {
      TPopup.successSnackbar(
          title: TTexts.success, message: 'Thank your for sharing our app!');
    }
  }

  // Emoticons
  List<MoodChoiceModel> getEmoticonsTheme() {
    switch (selectedEmoticons.value) {
      case 0:
        _localStorage.write(TLocalStorageKey.selectedEmoticon, 0);
        return MoodChoiceModel.defaultMood;
      case 1:
        _localStorage.write(TLocalStorageKey.selectedEmoticon, 1);
        return MoodChoiceModel.premiumMoods;
      default:
        _localStorage.write(TLocalStorageKey.selectedEmoticon, 0);
        return MoodChoiceModel.defaultMood;
    }
  }

  void readCurrentEmoticons() {
    _localStorage.writeIfNull(TLocalStorageKey.selectedEmoticon, 0);
    final emoticon = _localStorage.read(TLocalStorageKey.selectedEmoticon);
    selectedEmoticons.value = emoticon;
  }
}
