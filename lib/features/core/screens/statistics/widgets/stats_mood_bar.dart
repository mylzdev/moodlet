import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../controllers/statistic_controller.dart';
import 'stats_rounded_bar.dart';

class TStatsMoodBar extends StatelessWidget {
  const TStatsMoodBar({
    super.key,
    required this.controller,
  });

  final StatisticController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.moodCounts.every((mood) => mood.count == 0)) {
        return Row(
          children: [
            RoundedBar(color: Colors.black38, moodCount: 1.obs),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            controller.moodCounts.length,
            (index) {
              final moodColors = [
                TColors.great,
                TColors.good,
                TColors.okay,
                TColors.poor,
                TColors.bad
              ];
              return RoundedBar(
                color: moodColors[index],
                moodCount: controller.moodCounts[index].count.obs,
              );
            },
          ),
        );
      }
    });
  }
}
