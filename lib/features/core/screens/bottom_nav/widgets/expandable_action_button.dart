import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/mood_controller.dart';
import '../../../controllers/navigation_controller.dart';
import '../../../controllers/tutorial_controller.dart';
import '../../mood/mood.dart';
import 'action_bar_item.dart';

class TFloatingActionButton extends StatelessWidget {
  const TFloatingActionButton({
    super.key,
    required this.moodController,
    required this.navigationController,
  });

  final MoodController moodController;
  final NavigationController navigationController;

  @override
  Widget build(BuildContext context) {
    final bgColor = THelperFunctions.isDarkMode(context)
        ? TColors.darkContainer
        : TColors.lightContainer;

    return ExpandableFab(
      childrenOffset: const Offset(0, 10),
      type: ExpandableFabType.up,
      distance: 70,
      overlayStyle: const ExpandableFabOverlayStyle(
        color: Colors.black54,
        blur: 1.5,
      ),
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        backgroundColor: TColors.primary,
        child: Icon(
            key: TutorialController.instance.addMoodKey,
            Iconsax.add,
            color: Colors.white),
      ),
      closeButtonBuilder: RotateFloatingActionButtonBuilder(
        backgroundColor: TColors.primary,
        child: const Icon(Icons.close, color: Colors.white),
      ),
      children: [
        TActionBarItem(
          bgColor: bgColor,
          text: 'Today',
          icon: Iconsax.clock,
          onPressed: () {
            DateTime today = DateTime.now();
            moodController.createdAt.value = today;
            Get.to(() => const MoodScreen(), transition: Transition.downToUp);
          },
        ),
        TActionBarItem(
          bgColor: bgColor,
          text: 'Yesterday',
          icon: Iconsax.arrow_left,
          onPressed: () {
            DateTime yesterday =
                DateTime.now().subtract(const Duration(days: 1));
            moodController.createdAt.value = yesterday;
            Get.to(
              () => const MoodScreen(title: 'How were you yesterday?'),
              transition: Transition.downToUp,
            );
          },
        ),
        TActionBarItem(
          bgColor: bgColor,
          text: 'Other Day',
          icon: Iconsax.calendar,
          onPressed: () async =>
              navigationController.showDatePicker(DateTime.now()),
        ),
      ],
    );
  }
}
