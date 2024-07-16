import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/core/controllers/settings_controllers/settings_controller.dart';
import '../../features/core/screens/mood/mood.dart';
import '../../features/core/screens/settings/pages/setting_backup_data.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_functions.dart';
import '../../utils/logging/logger.dart';

class NotificationService {
  static const String dailyChannel = 'daily_channel';
  static const String backupChannel = 'backup_channel';

  // Initilize notification plugin
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Basic notification channel for Moodlet',
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelKey: dailyChannel,
          channelName: 'Schedule Notification',
          channelDescription: 'Schedule notification for Moodlet',
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
        NotificationChannel(
          channelKey: backupChannel,
          channelName: 'Backup Notification',
          channelDescription: 'Backup notification for Moodlet',
          channelShowBadge: true,
        ),
      ],
    );

    await AwesomeNotifications().setListeners(
      onNotificationCreatedMethod: onNotificationCreated,
      onActionReceivedMethod: onNotificationActionRecieved,
      onNotificationDisplayedMethod: onNotificationDisplayed,
      onDismissActionReceivedMethod: onNotificationdDismissed,
    );
  }

  // Method to detect if notification or scheduled is created
  static Future<void> onNotificationCreated(
      ReceivedNotification receivedNotification) async {
    TLoggerHelper.info('created');
  }

  // Method to detect if the notification is displayed
  static Future<void> onNotificationDisplayed(
      ReceivedNotification receivedNotification) async {
    TLoggerHelper.info('display');
  }

  // Method to detect if the user dismissed notification
  static Future<void> onNotificationActionRecieved(
      ReceivedNotification receivedNotification) async {
    if (receivedNotification.channelKey == dailyChannel) {
      await resetBadgeCounter();
    }
    await AwesomeNotifications().dismissAllNotifications();
    final payload = receivedNotification.payload!;
    if (payload['navigate'] == 'true') {
      Navigator.pushAndRemoveUntil(
        Get.context!,
        MaterialPageRoute(builder: (_) => const MoodScreen()),
        (route) => route.isFirst,
      );
    } else if (payload['backup'] == 'true') {
      Navigator.pushAndRemoveUntil(
        Get.context!,
        MaterialPageRoute(builder: (_) => const TSettingBackupData()),
        (route) => route.isFirst,
      );
    }

    TLoggerHelper.info('ACTION');
  }

  // Method to detect if the user dismissed notification
  static Future<void> onNotificationdDismissed(
      ReceivedNotification receivedNotification) async {
    TLoggerHelper.info('DISMISSED');
  }

  static Future<void> cancelScheduleNotification(String channelKey) async {
    AwesomeNotifications().cancelSchedulesByChannelKey(channelKey);
    TLoggerHelper.info('cancel $channelKey scheduled notification');
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  // Method to request notification permission
  static Future<bool> isNotificationAllowed() async {
    try {
      bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

      if (!isAllowed) {
        await Get.defaultDialog(
          title: 'Notification Request',
          titlePadding: const EdgeInsets.only(top: TSizes.spaceBtwItems),
          content: const Text(
            'Please enable the notification for daily reminder',
            textAlign: TextAlign.center,
          ),
          contentPadding: const EdgeInsets.fromLTRB(TSizes.defaultSpace,
              TSizes.defaultSpace, TSizes.defaultSpace, TSizes.sm),
          confirm: TextButton(
            onPressed: () async {
              AwesomeNotifications().requestPermissionToSendNotifications();
              Navigator.pop(Get.overlayContext!);
            },
            child: Text(
              'Confirm',
              style: Theme.of(Get.context!)
                  .textTheme
                  .titleMedium!
                  .apply(color: TColors.primary),
            ),
          ),
          cancel: TextButton(
            onPressed: () {
              Navigator.pop(Get.overlayContext!);
            },
            child: Text(
              'Cancel',
              style: Theme.of(Get.context!).textTheme.titleMedium,
            ),
          ),
        );

        // Recheck notification permission status after the user interaction
        isAllowed = await AwesomeNotifications().isNotificationAllowed();
      }

      return isAllowed;
    } catch (e) {
      TLoggerHelper.error(e.toString());
      return await AwesomeNotifications().isNotificationAllowed();
    }
  }

  static Future<void> createDailyReminderNotification() async {
    cancelScheduleNotification(NotificationService.dailyChannel);
    final time = SettingsController.instance.dailyTime.value!;
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: THelperFunctions.createUniqueId(),
        title: 'How is your day going?',
        body: 'Record your mood today',
        channelKey: dailyChannel,
        payload: {'navigate': 'true'},
        category: NotificationCategory.Reminder,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'SAVE MOOD',
          label: 'Save Mood',
        ),
      ],
      schedule: NotificationCalendar(
        hour: time.hour,
        minute: time.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
        preciseAlarm: true,
      ),
    );
  }

  static Future<void> createBackupReminder() async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: THelperFunctions.createUniqueId(),
        title: "Don't Forget to Backup Your Data!",
        body: 'Regular backups keep your data safe. Tap here to back up now',
        channelKey: backupChannel,
        payload: {'backup': 'true'},
        category: NotificationCategory.Reminder,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'BACKUP DATA',
          label: 'Backup Data',
        ),
      ],
      schedule: NotificationInterval(
        interval: 3 * 24 * 60 * 60,
        repeats: true,
        preciseAlarm: true,
      ),
    );
  }
}
