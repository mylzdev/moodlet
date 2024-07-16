import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/buttons/mood_filter_button.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/mood_controller.dart';
import '../../../controllers/tutorial_controller.dart';

class THomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const THomeAppbar({
    super.key,
    required this.tutorialController,
    required this.homeController,
    required this.moodController,
  });

  final TutorialController tutorialController;
  final HomeController homeController;
  final MoodController moodController;

  @override
  Widget build(BuildContext context) {
    return TAppbar(
      title: MoodFilterButton(
        key: tutorialController.filterKey,
        onPressed: () => homeController.isMoodFilterPressed.value =
            !homeController.isMoodFilterPressed.value,
      ),
      actions: [
        Obx(
          () => AbsorbPointer(
            absorbing: moodController.isFetchingLoading.value,
            child: IconButton(
              key: tutorialController.refreshKey,
              onPressed: () async {
                await moodController.fetchAllMoods();
              },
              icon: moodController.isFetchingLoading.value
                  ? const CircularProgressIndicator.adaptive()
                  : const Icon(Iconsax.refresh),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}