import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/settings_controllers/setting_backup_controller.dart';
import '../../../../../utils/constants/sizes.dart';

class TSettingRestoreWidget extends StatelessWidget {
  const TSettingRestoreWidget({super.key, required this.controller});

  final SettingBackupController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          controller.userHasBackup.value ? controller.confirmRestore() : () {},
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: TSizes.defaultSpace, vertical: TSizes.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Restore Data',
                        style: Theme.of(context).textTheme.titleMedium),
                    // Subtitle
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          controller.totalEntries.value != ''
                              ? Text(
                                  'Total Entries: ${controller.totalEntries.value}',
                                  maxLines: 2,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                )
                              : const SizedBox.shrink(),
                          Text(
                            controller.backupCreatedAt.value,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
