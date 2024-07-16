import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../data/respositories/mood_repository.dart';
import '../../../../data/services/backup_restore_service.dart';
import '../../../../data/services/notification_service.dart';
import '../mood_controller.dart';
import '../statistic_controller.dart';
import '../../../../utils/constants/local_storage_key.dart';
import '../../../../utils/popups/loader.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/popups.dart';

class SettingBackupController extends GetxController {
  static SettingBackupController get instance => Get.find();

  final _authRepo = AuthenticationService.instance;
  final _localStorage = GetStorage();
  final _backup = BackupRestoreService.instance;
  final _network = Get.put(NetworkManager());

  // Backup & Restore variables
  final automaticBackup = false.obs;
  final backupReminder = false.obs;

  final userHasBackup = false.obs;
  final totalEntries = ''.obs;
  final backupCreatedAt = ''.obs;
  final isDownloading = false.obs;
  final isRestoring = false.obs;

  final minimumEntries = 3;

  Rx<User?> authUser = Rx<User?>(null);

  @override
  void onInit() async {
    readToggleBackup();
    _network.connectionStatus.listen((value) async {
      if (value == ConnectivityResult.wifi ||
          value == ConnectivityResult.mobile) {
        authUser.value = _authRepo.authUser;
        if (authUser.value != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            TFullScreenLoader.openLoadingDialog('Loading', canPop: false);
          });

          backupCreatedAt.value = await _backup.getBackupCreationTime();
          userHasBackup.value = await _backup.userHasBackup;
          totalEntries.value = await _backup.retrieveTotalEntries();

          TFullScreenLoader.stopLoading();
        }
      }
    });

    super.onInit();
  }

  // Switch
  Future<void> toggleAutomaticOrManualBackup(bool isAutomatic) async {
    if (isAutomatic) {
      automaticBackup.value = !automaticBackup.value;
      _localStorage.write(
          TLocalStorageKey.automaticBackup, automaticBackup.value);
    } else {
      backupReminder.value = !backupReminder.value;
      _localStorage.write(
          TLocalStorageKey.backupReminder, backupReminder.value);

      if (backupReminder.value) {
        await NotificationService.createBackupReminder();
      } else {
        NotificationService.cancelScheduleNotification(
            NotificationService.backupChannel);
      }
    }
  }

  void readToggleBackup() {
    var toggleAutomatic = _localStorage.read(TLocalStorageKey.automaticBackup);
    if (toggleAutomatic != null) {
      automaticBackup.value = toggleAutomatic;
    }

    var toggleBackupReminder =
        _localStorage.read(TLocalStorageKey.backupReminder);
    if (toggleBackupReminder != null) {
      backupReminder.value = toggleBackupReminder;
    }
  }

  // Backup & Restore
  Future<void> googleSignIn() async {
    try {
      // Check internet connectivity
      final isConnected = await _network.isConnected();
      if (!isConnected) {
        TPopup.errorSnackbar(
            title: TTexts.ohSnap,
            message: 'Please check your internet connectivity and try again');
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        TFullScreenLoader.openLoadingDialog('Loading');
      });

      // Google authentication

      final credential = await _authRepo.signInWithGoogle();
      authUser.value = credential.user;

      backupCreatedAt.value = await _backup.getBackupCreationTime();
      userHasBackup.value = await _backup.userHasBackup;
      totalEntries.value = await _backup.retrieveTotalEntries();

      TPopup.successSnackbar(
          title: TTexts.success, message: 'Logged in success');
    } catch (e) {
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    } finally {
      TFullScreenLoader.stopLoading();
    }
  }

  void confirmLogout() {
    Get.defaultDialog(
      backgroundColor: THelperFunctions.isDarkMode(Get.context!)
          ? TColors.dark
          : TColors.light,
      contentPadding: const EdgeInsets.all(TSizes.md),
      titlePadding: const EdgeInsets.only(top: TSizes.md),
      title: 'Logging out',
      middleText: 'Are you sure you want to log out?',
      // Confirm button
      confirm: ElevatedButton(
        onPressed: () async {
          Navigator.of(Get.overlayContext!).pop();
          await logout();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.zero,
            side: BorderSide.none),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Logout'),
        ),
      ),
      // Cancel button
      cancel: OutlinedButton(
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Cancel'),
        ),
      ),
    );
  }

  Future<void> logout() async {
    try {
      // Check internet connectivity
      final isConnected = await _network.isConnected();
      if (!isConnected) {
        TPopup.errorSnackbar(
            title: TTexts.ohSnap,
            message: 'Please check your internet connectivity and try again');
        return;
      }

      await _authRepo.logout();
      authUser.value = null;
    } catch (e) {
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    }
  }

  void confirmBackup() async {
    await Get.defaultDialog(
      backgroundColor: THelperFunctions.isDarkMode(Get.context!)
          ? TColors.dark
          : TColors.light,
      contentPadding: const EdgeInsets.all(TSizes.md),
      titlePadding: const EdgeInsets.only(top: TSizes.md),
      title: 'Backup warning',
      middleText: 'The existing backup will be override',
      // Confirm button
      confirm: ElevatedButton(
        onPressed: () async {
          Navigator.of(Get.overlayContext!).pop();
          await backupDatabase();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: TColors.primary,
            padding: EdgeInsets.zero,
            side: BorderSide.none),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Backup'),
        ),
      ),
      // Cancel button
      cancel: OutlinedButton(
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Cancel'),
        ),
      ),
    );
  }

  void confirmRestore() async {
    await Get.defaultDialog(
      backgroundColor: THelperFunctions.isDarkMode(Get.context!)
          ? TColors.dark
          : TColors.light,
      contentPadding: const EdgeInsets.all(TSizes.md),
      titlePadding: const EdgeInsets.only(top: TSizes.md),
      title: 'Restore backup',
      middleText: 'The existing entries wxill be override',
      // Confirm button
      confirm: ElevatedButton(
        onPressed: () async {
          Navigator.of(Get.overlayContext!).pop();
          await restoreDatabase();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: TColors.primary,
            padding: EdgeInsets.zero,
            side: BorderSide.none),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Restore'),
        ),
      ),
      // Cancel button
      cancel: OutlinedButton(
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Cancel'),
        ),
      ),
    );
  }

  Future<void> backupDatabase() async {
    try {
      final isConnected = await _network.isConnected();
      if (!isConnected) {
        TPopup.errorSnackbar(
            title: TTexts.ohSnap,
            message: 'Please check your internet connectivity and try again');
        return;
      }

      final entries = await MoodRepository.instance.getTotalEntries();
      if (entries < minimumEntries) {
        TPopup.warningSnackbar(
            title: TTexts.ohSnap,
            message:
                'To make a backup, you must have at least $minimumEntries or more entries');
        return;
      }

      TFullScreenLoader.openLoadingDialog('Creating a backup...');

      await _backup.backupDatabase();

      totalEntries.value = await _backup.retrieveTotalEntries();
      backupCreatedAt.value = await _backup.getBackupCreationTime();
      userHasBackup.value = await _backup.userHasBackup;
      TFullScreenLoader.stopLoading();

      isDownloading.value = true;
      await _backup.backupImages();

      TPopup.successSnackbar(title: TTexts.success, message: 'Backup created');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    } finally {
      isDownloading.value = false;
    }
  }

  Future<void> restoreDatabase() async {
    try {
      final isConnected = await _network.isConnected();
      if (!isConnected) {
        TPopup.errorSnackbar(
            title: TTexts.ohSnap,
            message: 'Please check your internet connectivity and try again');
        return;
      }
      TFullScreenLoader.openLoadingDialog('Loading');

      await _backup.restoreDatabase();
      totalEntries.value = await _backup.retrieveTotalEntries();
      TFullScreenLoader.stopLoading();

      isRestoring.value = true;
      await _backup.restoreImages();
      MoodController.instance.fetchAllMoods();
      StatisticController.instance.getMoodCountsByDate(DateTime.now());

      TPopup.successSnackbar(
          title: TTexts.success, message: 'Sucessfuly restore the images');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    } finally {
      isRestoring.value = false;
    }
  }
}
