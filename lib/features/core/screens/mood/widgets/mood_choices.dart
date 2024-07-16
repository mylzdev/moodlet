import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/settings_controllers/settings_controller.dart';
import '../../../models/mood_model/mood_model.dart';
import '../../../controllers/mood_controller.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';

class MoodChoices extends StatelessWidget {
  const MoodChoices({
    super.key,
    this.moodSize = 50,
    this.textColor,
    this.hasTitle = true,
    this.hasBadge = false,
    this.useFilter = false,
    this.shouldFetchMood = true,
    this.moodCount,
  });

  final double moodSize;
  final RxList<MoodCount>? moodCount;
  final Color? textColor;
  final bool hasTitle, hasBadge, shouldFetchMood;
  final bool useFilter;

  @override
  Widget build(BuildContext context) {
    final controller = MoodController.instance;
    final moods = SettingsController.instance.getEmoticonsTheme();
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 80,
      child: Center(
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: moods.length,
          separatorBuilder: (_, __) =>
              SizedBox(width: width / TSizes.spaceBtwSections),
          itemBuilder: (_, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                hasBadge
                    ? Badge(
                        label: Obx(() => Text(moodCount == null
                            ? '0'
                            : moodCount![index].count.obs.toString())),
                        textColor: Colors.black,
                        backgroundColor: TColors.secondary,
                        child: Image.asset(
                          moods[index].moodImage,
                          height: moodSize,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          // Set the mood
                          controller.moodSelectedName.value =
                              moods[index].moodText;
                          if (shouldFetchMood) {
                            controller.fetchSingleMoodById();
                          }
                        },
                        child: ClipOval(child: Obx(() {
                          return ColorFiltered(
                            colorFilter: moods[index].moodText !=
                                        controller.moodSelectedName.value &&
                                    !useFilter
                                // Selected Mood -----------------------------------------------
                                ? const ColorFilter.mode(
                                    TColors.grey, BlendMode.color)
                                : const ColorFilter.mode(
                                    Colors.white, BlendMode.dst),
                            child: Image.asset(
                              moods[index].moodImage,
                              height: moodSize,
                            ),
                          );
                        })),
                      ).marginOnly(bottom: TSizes.xs),
                if (hasTitle)
                  SizedBox(
                    width: 40,
                    child: Center(
                      child: Text(
                        moods[index].moodText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .apply(color: textColor),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
