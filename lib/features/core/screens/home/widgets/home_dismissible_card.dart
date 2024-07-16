import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/icon/circular_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../controllers/mood_controller.dart';
import '../../../models/mood_model/mood_model.dart';
import 'home_mood_card_content.dart';

class THomeDismissibleMoodCard extends StatelessWidget {
  const THomeDismissibleMoodCard({
    super.key,
    required this.moodIndex,
    required this.moodController,
    required this.mood,
  });

  final int moodIndex;
  final MoodController moodController;
  final MoodModel mood;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<int>(moodIndex),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await moodController.fetchSingleMoodById(moodId: moodIndex);
          return false;
        } else {
          final isRemove =
              await moodController.removeMoodPopup(moodIndex, false);
          return isRemove;
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          moodController.deleteMoodById(moodIndex);
        }
      },
      background: const Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 50,
            child: TCircularIcon(
              icon: Iconsax.edit,
            ),
          ),
        ],
      ),
      secondaryBackground: const Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 50,
            child: TCircularIcon(
              icon: Iconsax.trash,
              backgroundColor: TColors.error,
            ),
          ),
        ],
      ),
      child: THomeMoodCardContent(moodData: mood),
    );
  }
}
