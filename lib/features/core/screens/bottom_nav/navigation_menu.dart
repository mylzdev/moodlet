import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';

import '../../controllers/mood_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../controllers/tutorial_controller.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/expandable_action_button.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = NavigationController.instance;
    final moodController = MoodController.instance;
    final tutorialController = Get.put(TutorialController(), permanent: true);
    return Scaffold(
      extendBody: true,
      floatingActionButton: TFloatingActionButton(
        moodController: moodController,
        navigationController: navigationController,
        tutorialController: tutorialController,
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      bottomNavigationBar: TBottomNavBar(
        navigationController: navigationController,
        tutorialController: tutorialController,
      ),
      // Navigation Body
      body: Obx(() =>
          navigationController.screens[navigationController.navbarIndex.value]),
    );
  }
}
