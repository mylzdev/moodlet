import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../features/core/controllers/home_controller.dart';
import '../../../features/core/controllers/mood_controller.dart';
import '../../../features/core/controllers/settings_controllers/settings_controller.dart';
import '../../../features/core/models/mood_model/mood_choice_model.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class MoodFilterButton extends StatelessWidget {
  const MoodFilterButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final homeController = HomeController.instance;
    final moodController = MoodController.instance;
    return GestureDetector(
      onTap: onPressed,
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          padding: const EdgeInsets.only(left: TSizes.sm),
          height: 40,
          width: homeController.isMoodFilterPressed.value ? 250 : 80,
          decoration: BoxDecoration(
            color: isDark ? TColors.darkContainer : TColors.lightContainer,
            borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                isDark ? TImages.moodlessDark : TImages.moodlessLight,
                height: 30,
              ),
              const SizedBox(width: 5),
              Visibility(
                visible: homeController.isMoodFilterPressed.value,
                child: Expanded(
                  child: OverflowBox(
                    maxWidth: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ...List.generate(
                          MoodChoiceModel.defaultMood.length,
                          (index) => GestureDetector(
                            onTap: () async {
                              moodController.filterMoodsByTitle(
                                  MoodChoiceModel.defaultMood[index].moodText);
                              homeController.isMoodFilterPressed.value =
                                  !homeController.isMoodFilterPressed.value;
                            },
                            child: Image.asset(
                              SettingsController.instance
                                  .getEmoticonsTheme()[index]
                                  .moodImage,
                              height: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Transform.flip(
                flipX: homeController.isMoodFilterPressed.value ? true : false,
                child: Icon(
                  Icons.arrow_right_rounded,
                  size: TSizes.iconLg,
                  color: isDark ? TColors.white : TColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
