import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/shapes/container/card_container.dart';
import '../../../../../common/widgets/shapes/container/rounded_container.dart';
import '../../../../../data/services/notification_service.dart';
import '../../../controllers/settings_controllers/settings_controller.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TSettingsDailyReminder extends StatelessWidget {
  const TSettingsDailyReminder({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.instance;
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: true,
        title: Text(
          'Daily Reminder',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            TCardContainer(
              padding: const EdgeInsets.all(TSizes.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Time
                  GestureDetector(
                    onTap: () => controller.showTimePicker(),
                    child: TRoundedContainer(
                      padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.md, vertical: TSizes.sm),
                      backgroundColor: THelperFunctions.isDarkMode(context)
                          ? TColors.dark
                          : TColors.darkSoftGrey,
                      child: Obx(
                        () => Row(
                          children: [
                            controller.dailyTime.value != null
                                ? Text(
                                    controller.dailyTime.value!.format(context),
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  )
                                : Text(
                                    'No Time Selected',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                            const SizedBox(width: TSizes.spaceBtwItems),
                            const Icon(Iconsax.edit)
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Switch
                  Obx(
                    () => Switch(
                      activeColor: THelperFunctions.isDarkMode(context)
                          ? TColors.secondary
                          : TColors.primary,
                      value: controller.dailyReminderSwitch.value,
                      onChanged: (value) async {
                        final isAllowed =
                            await NotificationService.isNotificationAllowed();
                        if (isAllowed) {
                          controller.toggleDailyReminder(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
