import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/shapes/container/primay_header_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../controllers/statistic_controller.dart';
import '../../calendar/widgets/calendar_month_year_picker.dart';
import '../../mood/widgets/mood_choices.dart';
import 'stats_mood_bar.dart';

class TStatsHeaderAndBar extends StatelessWidget {
  const TStatsHeaderAndBar({
    super.key,
    required this.controller,
  });

  final StatisticController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.moodCounts.isEmpty) {
        return SizedBox(
            height: 270, child: TPrimaryHeaderContainer(child: Container()));
      } else {
        return SizedBox(
          height: 270,
          child: TPrimaryHeaderContainer(
            child: Column(
              children: [
                // Appbar
                SizedBox(
                  height: TDeviceUtils.getAppBarHeight(),
                  width: double.infinity,
                ),
                // Month Picker
                const TCalendarMonthYearPicker(textColor: Colors.black),
                const SizedBox(height: TSizes.spaceBtwItems),
                // Title
                Text('Mood Bar',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .apply(color: Colors.black)),
                const SizedBox(
                    width: 100, child: Divider(color: TColors.darkGrey)),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                // Mood bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.defaultSpace),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: SizedBox(
                      height: 30,
                      child: TStatsMoodBar(controller: controller),
                    ),
                  ),
                ),
                // Mood Count
                MoodChoices(
                  moodCount: controller.moodCounts,
                  moodSize: TSizes.iconLg,
                  hasBadge: true,
                  textColor: Colors.black,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
              ],
            ),
          ),
        );
      }
    });
  }
}
