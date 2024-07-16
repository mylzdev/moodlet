import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/bottom_nav/navigation_menu.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import 'mood_controller.dart';

class MoodDetailsController extends GetxController {
  final moodController = MoodController.instance;

  void confirmDataNotSave() {
    MoodController.instance.clearFieldsAndSelection();
    Get.offAll(() => const NavigationScreen(), transition: Transition.zoom);
  }

  Future<void> showDataNotSaveDialog() async {
    await Get.defaultDialog(
      backgroundColor: THelperFunctions.isDarkMode(Get.context!)
          ? TColors.dark
          : TColors.light,
      contentPadding: const EdgeInsets.all(TSizes.md),
      titlePadding: const EdgeInsets.only(top: TSizes.md),
      title: 'Data not save',
      middleText: 'Are you sure you want continue?',
      // Confirm button
      confirm: ElevatedButton(
        onPressed: () => confirmDataNotSave(),
        style: ElevatedButton.styleFrom(
            backgroundColor: TColors.primary,
            padding: EdgeInsets.zero,
            side: BorderSide.none),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Confirm'),
        ),
      ),
      // Cancel button
      cancel: OutlinedButton(
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Back'),
        ),
      ),
    );
  }
}
