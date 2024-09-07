import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/formatters/formatter.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/mood_controller.dart';
import '../../controllers/mood_details_controller.dart';
import '../../models/mood_model/mood_model.dart';
import 'widgets/mood_details_activities/mood_details_activities.dart';
import 'widgets/mood_details_choices/mood_detail_choices.dart';
import 'widgets/mood_details_emotion/mood_details_emotion.dart';
import 'widgets/mood_details_note/mood_details_note.dart';
import 'widgets/mood_details_photo/mood_details_photo.dart';
import 'widgets/mood_details_sleep/mood_details_sleep.dart';

class MoodDetailsScreen extends StatelessWidget {
  const MoodDetailsScreen(
      {super.key, this.moodData, this.showBackArrow = true});

  final MoodModel? moodData;
  final bool showBackArrow;

  @override
  Widget build(BuildContext context) {
    final controller = MoodController.instance;
    final moodDetailsController = Get.put(MoodDetailsController());
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) =>
          moodDetailsController.showDataNotSaveDialog(),
      child: Scaffold(
        appBar: TAppbar(
          leadingWidget: showBackArrow
              ? IconButton(
                  onPressed: () =>
                      moodDetailsController.showDataNotSaveDialog(),
                  icon: Icon(
                    Iconsax.arrow_left,
                    color: THelperFunctions.isDarkMode(context)
                        ? TColors.grey
                        : TColors.black,
                  ),
                )
              : null,
          title: Obx(
              () => Text(TFormatter.formatDate(controller.createdAt.value))),
          actions: [
            IconButton(
              onPressed: () async => moodData == null
                  ? controller.addMood()
                  : controller.updateMood(moodData!.id!),
              icon: const Icon(Icons.check),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                // -- Mood
                const TMoodDetailsChoices(),
                // -- Note
                const TMoodDetailsNote(),
                // -- Emotions
                const TMoodDetailsEmotions(),
                // -- Activites
                const TMoodDetailsActivities(),
                // -- Sleep
                const TMoodDetailsSleep(),
                // -- Photo
                const TMoodDetailsPhoto(),
                // -- Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async => moodData == null
                        ? controller.addMood()
                        : controller.updateMood(moodData!.id!),
                    child: Text(moodData == null ? 'Save' : 'Update'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
