import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/buttons/mood_filter_button.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/mood_controller.dart';
import '../../../controllers/tutorial_controller.dart';

class THomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const THomeAppbar({
    super.key,
    required this.homeController,
    required this.moodController,
  });

  final HomeController homeController;
  final MoodController moodController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: MoodFilterButton(
        key: TutorialController.instance.filterKey,
        onPressed: () => homeController.isMoodFilterPressed.value =
            !homeController.isMoodFilterPressed.value,
      ),
      actions: [
        IconButton(
          key: TutorialController.instance.refreshKey,
          onPressed: () async => await moodController.fetchAllMoods(),
          icon: const Icon(Iconsax.refresh),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
