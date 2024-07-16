import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/mood_controller.dart';
import '../../../../../../utils/formatters/formatter.dart';
import '../../../../../../common/widgets/card/mood_details_card.dart';

class TMoodDetailsSleep extends StatelessWidget {
  const TMoodDetailsSleep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MoodController.instance;
    return TMoodDetailsCard(
      cardTitle: 'Sleep',
      cardTontent: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => controller.showBottomSheetTimePicker(),
          child: Obx(() => controller.intervalBedTime.value.h == 0 &&
                  controller.intervalBedTime.value.m == 0
              ? const Text('Record your sleep')
              : Text(TFormatter.formatSleepTime(
                  controller.intervalBedTime.value, true))),
        ),
      ),
    );
  }
}
