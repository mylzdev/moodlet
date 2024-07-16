import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../controllers/settings_controllers/setting_backup_controller.dart';
import '../../../../../utils/constants/image_strings.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TBackupAutomaticWidget extends StatelessWidget {
  const TBackupAutomaticWidget({
    super.key,
    this.isAutomatic = true,
    this.isPremium = true,
    this.title,
    this.subtitle,
    required this.controller,
  });

  final bool isAutomatic, isPremium;
  final String? title, subtitle;
  final SettingBackupController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.toggleAutomaticOrManualBackup(isAutomatic),
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
                      Row(
                        children: [
                          Text(
                            title ?? 'Automatic Backup  ',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if(isPremium) SvgPicture.asset(TImages.crown, width: TSizes.iconSm),
                        ],
                      ),
                      // Subtitle
                      Text(
                        subtitle ??
                            'Turn on automatic backup to avoid forgetting to synchronize your data',
                        maxLines: 2,
                        style: Theme.of(context).textTheme.labelMedium,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: TSizes.lg),
                  child: Switch.adaptive(
                    activeColor: THelperFunctions.isDarkMode(context)
                        ? TColors.secondary
                        : TColors.primary,
                    value: isAutomatic
                        ? controller.automaticBackup.value
                        : controller.backupReminder.value,
                    onChanged: (value) =>
                        controller.toggleAutomaticOrManualBackup(isAutomatic),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
