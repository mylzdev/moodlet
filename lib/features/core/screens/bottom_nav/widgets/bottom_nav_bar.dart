import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/navigation_controller.dart';
import '../../../controllers/tutorial_controller.dart';

class TBottomNavBar extends StatelessWidget {
  const TBottomNavBar({super.key, required this.navigationController});

  final NavigationController navigationController;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Obx(
      () => SalomonBottomBar(
        currentIndex: navigationController.navbarIndex.value,
        selectedItemColor: TColors.primary,
        unselectedItemColor: isDark ? Colors.white : Colors.black,
        backgroundColor:
            isDark ? TColors.darkContainer : TColors.lightContainer,
        items: [
          // Home
          SalomonBottomBarItem(
            icon: Icon(
              key: TutorialController.instance.entriesKey,
              Iconsax.home,
              color: isDark ? Colors.white : Colors.black,
            ),
            title: Text(
              "Entries",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            selectedColor:
                isDark ? TColors.lightContainer : TColors.darkContainer,
          ),
          // Statistics
          SalomonBottomBarItem(
            icon: Icon(
              key: TutorialController.instance.statisticKey,
              Iconsax.activity,
              color: isDark ? Colors.white : Colors.black,
            ),
            title: Text(
              "Stats",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            selectedColor:
                isDark ? TColors.lightContainer : TColors.darkContainer,
          ),
          // Statistics
          SalomonBottomBarItem(
            icon: Icon(
              key: TutorialController.instance.calendaryKey,
              Iconsax.calendar,
              color: isDark ? Colors.white : Colors.black,
            ),
            title: Text(
              "Calendar",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            selectedColor:
                isDark ? TColors.lightContainer : TColors.darkContainer,
          ),
          // Statistics
          SalomonBottomBarItem(
            icon: Icon(
              key: TutorialController.instance.settingsKey,
              Iconsax.setting,
              color: isDark ? Colors.white : Colors.black,
            ),
            title: Text(
              "Settings",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            selectedColor:
                isDark ? TColors.lightContainer : TColors.darkContainer,
          ),
        ],
        onTap: (index) {
          navigationController.navbarIndex.value = index;
        },
      ),
    );
  }
}
