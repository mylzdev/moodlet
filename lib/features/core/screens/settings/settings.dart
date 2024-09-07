import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/list_tile/settings_tile.dart';
import '../../../../common/widgets/shapes/container/card_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/settings_controllers/settings_controller.dart';
import 'pages/setting_backup_data.dart';
import 'pages/settings_contact_us.dart';
import 'pages/settings_daily_reminder.dart';
import 'pages/settings_display_mode.dart';
import 'pages/settings_emoticons.dart';
import 'pages/settings_passcode.dart';
import 'pages/settings_photo_gallery.dart';
import 'pages/settings_username.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: TAppbar(
        centerTitle: true,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // Opacity(
              //   opacity: 0.5,
              //   child: TCardContainer(
              //     padding: EdgeInsets.zero,
              //     isHeading: true,
              //     child: ListTile(
              //       title: Text(
              //         'Upgrade to Premium (Soon)',
              //         style: Theme.of(context)
              //             .textTheme
              //             .titleMedium!
              //             .apply(color: Colors.black),
              //       ),
              //       leading: Image.asset(TImages.defaultGreat, height: 40),
              //       trailing:
              //           const Icon(Iconsax.arrow_right, color: Colors.black),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: TSizes.spaceBtwItems * 1.5),
              TCardContainer(
                width: double.infinity,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    TSettingsTile(
                      onPresed: () => Get.to(
                        () => const TSettingsDailyReminder(),
                        transition: Transition.rightToLeft,
                      ),
                      title: 'Daily Reminder',
                      leadingIcon: Iconsax.notification,
                    ),
                    Divider(
                      height: 16,
                      color: isDark ? TColors.darkGrey : TColors.darkGrey,
                    ),
                    TSettingsTile(
                      onPresed: () => Get.to(
                        () => const TSettingBackupData(),
                        transition: Transition.rightToLeft,
                      ),
                      title: 'Backup Data',
                      leadingIcon: Icons.backup_outlined,
                    ),
                    Divider(
                      height: 16,
                      color: isDark ? TColors.darkGrey : TColors.darkGrey,
                    ),
                    TSettingsTile(
                      onPresed: () => Get.to(() => const TSettingsPasscode(),
                          transition: Transition.rightToLeft),
                      title: 'Passcode Lock',
                      leadingIcon: Icons.lock_outline_rounded,
                    ),
                    Divider(
                      height: 16,
                      color: isDark ? TColors.darkGrey : TColors.darkGrey,
                    ),
                    TSettingsTile(
                      onPresed: () => Get.to(() => const UsernameScreen(),
                          transition: Transition.rightToLeft),
                      title: 'Username',
                      leadingIcon: Icons.person_2_outlined,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems * 1.5),
              TCardContainer(
                width: double.infinity,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    TSettingsTile(
                      onPresed: () => Get.to(
                        () => const TSettingsDisplayMode(),
                        transition: Transition.rightToLeft,
                      ),
                      title: 'Display Mode',
                      leadingIcon: Iconsax.moon,
                    ),
                    Divider(
                      height: 16,
                      color: isDark ? TColors.darkGrey : TColors.darkGrey,
                    ),
                    TSettingsTile(
                      onPresed: () => Get.to(
                        () => const TSettingsEmoticons(),
                        transition: Transition.rightToLeft,
                      ),
                      title: 'Emoticons',
                      leadingIcon: Icons.emoji_emotions_outlined,
                    ),
                    Divider(
                      height: 16,
                      color: isDark ? TColors.darkGrey : TColors.darkGrey,
                    ),
                    TSettingsTile(
                      onPresed: () => Get.to(
                        () => const TSettingsPhotoGallery(),
                        transition: Transition.rightToLeft,
                      ),
                      title: 'Photo Gallery',
                      leadingIcon: Iconsax.gallery,
                    ),
                    // Divider(
                    //   height: 16,
                    //   color: isDark ? TColors.darkGrey : TColors.darkGrey,
                    // ),
                    // Opacity(
                    //   opacity: 0.5,
                    //   child: TSettingsTile(
                    //     onPresed: () {},
                    //     title: 'Widgets',
                    //     leadingIcon: Icons.widgets_outlined,
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems * 1.5),
              TCardContainer(
                width: double.infinity,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    TSettingsTile(
                      onPresed: () => Get.to(() => const TSettingsContactUs(),
                          transition: Transition.rightToLeft),
                      title: 'Contact Us',
                      leadingIcon: Iconsax.message,
                    ),
                    Divider(
                      height: 16,
                      color: isDark ? TColors.darkGrey : TColors.darkGrey,
                    ),
                    // TSettingsTile(
                    //   onPresed: () {},
                    //   title: 'Rate App',
                    //   leadingIcon: Iconsax.star,
                    // ),
                    // Divider(
                    //   height: 16,
                    //   color: isDark ? TColors.darkGrey : TColors.darkGrey,
                    // ),
                    TSettingsTile(
                      onPresed: () =>
                          SettingsController.instance.shareWithFriends(),
                      title: 'Share with Friends',
                      leadingIcon: Iconsax.share,
                    ),
                  ],
                ),
              ),
              SizedBox(height: height / 8),
            ],
          ),
        ),
      ),
    );
  }
}
