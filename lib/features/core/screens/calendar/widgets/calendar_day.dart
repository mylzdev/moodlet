import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../controllers/mood_controller.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TCalendarDayContainer extends StatelessWidget {
  const TCalendarDayContainer({
    super.key,
    required this.day,
    this.isToday = false,
  });

  final DateTime day;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () {
              final moodImage = MoodController.instance.getMoodImageForDay(day);
              return Container(
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isToday
                        ? TColors.primary
                        : isDark
                            ? TColors.darkContainer
                            : TColors.lightContainer,
                    shape: BoxShape.circle,
                  ),
                  child: moodImage != null
                      ? Image.asset(moodImage)
                      : const Icon(Iconsax.add));
            },
          ),
          const SizedBox(height: TSizes.xs),
          Text(
            '${day.day}',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
