import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../controllers/settings_controllers/setting_backup_controller.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TSettingBackupHeader extends StatelessWidget {
  const TSettingBackupHeader({
    super.key,
    required this.controller,
  });

  final SettingBackupController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.authUser.value == null
            ? controller.googleSignIn()
            : () {},
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: TSizes.defaultSpace, vertical: TSizes.md),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: THelperFunctions.isDarkMode(context)
                      ? TColors.darkContainer
                      : TColors.lightContainer,
                  child: Padding(
                    padding: controller.authUser.value != null
                        ? EdgeInsets.zero
                        : const EdgeInsets.all(TSizes.sm),
                    child: controller.authUser.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                                fadeInDuration: Duration.zero,
                                imageUrl: controller.authUser.value!.photoURL!),
                          )
                        : const Icon(Icons.cloud_upload),
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          controller.authUser.value?.displayName ??
                              'Backup to Cloud Storage',
                          style: Theme.of(context).textTheme.titleMedium),
                      // Subtitle
                      Text(
                        controller.authUser.value?.email ??
                            'Tap to connect account',
                        maxLines: 2,
                        style: Theme.of(context).textTheme.labelMedium,
                      )
                    ],
                  ),
                ),
                if (controller.authUser.value != null)
                  IconButton(
                    onPressed: () => controller.confirmLogout(),
                    icon: const Icon(Iconsax.logout),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
