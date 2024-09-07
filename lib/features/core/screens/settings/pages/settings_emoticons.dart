import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/shapes/container/card_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/settings_controllers/settings_controller.dart';
import '../../../models/mood_model/mood_choice_model.dart';

class TSettingsEmoticons extends StatelessWidget {
  const TSettingsEmoticons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.instance;
    final moods = MoodChoiceModel.moods;
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: true,
        title: Text(
          'Emoticons',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ListView.builder(
          itemCount: moods.length,
          itemBuilder: (context, moodListIndex) {
            final moodList = moods[moodListIndex];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems),
              child: GestureDetector(
                onTap: () => controller.selectedEmoticons.value = moodListIndex,
                child: Obx(
                  () => TCardContainer(
                    padding: const EdgeInsets.all(TSizes.md),
                    backgroundColor:
                        controller.selectedEmoticons.value == moodListIndex
                            ? TColors.secondary
                            : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(moodList.length, (moodIndex) {
                        final mood = moodList[moodIndex];
                        return Column(
                          children: [
                            Image.asset(
                              mood.moodImage,
                              height: 50,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              mood.moodText,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .apply(
                                    color: controller.selectedEmoticons.value ==
                                            moodListIndex
                                        ? TColors.black
                                        : THelperFunctions.isDarkMode(context)
                                            ? TColors.white
                                            : TColors.black,
                                  ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
