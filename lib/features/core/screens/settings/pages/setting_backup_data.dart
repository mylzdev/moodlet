import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../data/services/backup_restore_service.dart';
import '../../../controllers/settings_controllers/setting_backup_controller.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../widgets/automatic_manual_backup.dart';
import '../widgets/setting_backup_header.dart';
import '../widgets/restore_data.dart';

class TSettingBackupData extends StatelessWidget {
  const TSettingBackupData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingBackupController(), permanent: true);
    return Scaffold(
      appBar: TAppbar(
        title: Text('Backup & Restore',
            style: Theme.of(context).textTheme.headlineSmall),
        showBackArrow: true,
      ),
      body: Obx(
        () => Column(
          children: [
            Visibility(
              visible: controller.isDownloading.value ||
                  controller.isRestoring.value,
              child: const LinearProgressIndicator(color: TColors.primary),
            ),
            TSettingBackupHeader(controller: controller),
            const Divider(),
            // TBackupAutomaticWidget(
            //   controller: controller,
            //   isAutomatic: true,
            // ),
            // const Divider(),
            TBackupAutomaticWidget(
              controller: controller,
              isAutomatic: false,
              isPremium: false,
              title: 'Backup Reminder',
              subtitle: 'Turn on backup reminder to manually backup your data',
            ),
            const Divider(),
            controller.authUser.value != null
                ? Column(
                    children: [
                      TSettingRestoreWidget(controller: controller),
                      const Divider(),
                    ],
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: TSizes.spaceBtwItems),
            TBackupLoadingWidget(controller: controller),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        return controller.authUser.value != null
            ? Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: ElevatedButton(
                  onPressed: () async => controller.userHasBackup.value
                      ? controller.confirmBackup()
                      : controller.backupDatabase(),
                  child: const Text('Backup Data'),
                ),
              )
            : const SizedBox.shrink();
      }),
    );
  }
}

class TBackupLoadingWidget extends StatelessWidget {
  const TBackupLoadingWidget({super.key, required this.controller});

  final SettingBackupController controller;

  @override
  Widget build(BuildContext context) {
    final images = BackupRestoreService.instance;
    return Obx(
      () => Visibility(
        visible: controller.isDownloading.value || controller.isRestoring.value,
        child: Column(
          children: [
            Text(
              controller.isDownloading.value
                  ? 'Saving Images'
                  : 'Restoring Images',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: TSizes.xs),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: controller.isDownloading.value
                          ? images.backedUpImages.toString()
                          : images.restoredImages.toString()),
                  const TextSpan(text: ' / '),
                  TextSpan(
                      text: controller.isDownloading.value
                          ? images.totalBackupImages.toString()
                          : images.totalRestoreImages.toString()),
                ],
              ),
            ),
            const Divider()
          ],
        ),
      ),
    );
  }
}
