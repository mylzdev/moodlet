import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/mood_controller.dart';
import 'sleep_time_widget.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/formatters/formatter.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';

class MoodDetailsSleepTimePicker extends StatelessWidget {
  const MoodDetailsSleepTimePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MoodController.instance;
    final isDark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        // -- Time picker
        Obx(
          () => TimePicker(
            initTime: controller.inBedTime.value,
            endTime: controller.outBedTime.value,
            height: 230.0,
            width: 230.0,
            onSelectionChange: (a, b, valid) => controller.updateLabels(a, b),
            onSelectionEnd: (a, b, valid) => controller.updateLabels(a, b),
            primarySectors: controller.clockTimeFormat.value,
            secondarySectors: controller.clockTimeFormat.value * 2,
            decoration: TimePickerDecoration(
              baseColor: isDark ? TColors.darkContainer : TColors.darkSoftGrey,
              pickerBaseCirclePadding: 15.0,
              sweepDecoration: TimePickerSweepDecoration(
                pickerStrokeWidth: 30.0,
                pickerColor: TColors.primary,
                showConnector: true,
              ),
              initHandlerDecoration: TimePickerHandlerDecoration(
                color: const Color(0xFF141925),
                shape: BoxShape.circle,
                radius: 12.0,
                icon: const Icon(
                  Icons.dark_mode,
                  size: 20.0,
                  color: TColors.secondary,
                ),
              ),
              endHandlerDecoration: TimePickerHandlerDecoration(
                color: const Color(0xFF141925),
                shape: BoxShape.circle,
                radius: 12.0,
                icon: const Icon(
                  Icons.light_mode,
                  size: 20.0,
                  color: TColors.secondary,
                ),
              ),
              primarySectorsDecoration: TimePickerSectorDecoration(
                color: isDark ? Colors.white : Colors.black,
                width: 1.0,
                size: 4.0,
                radiusPadding: 25,
              ),
              secondarySectorsDecoration: TimePickerSectorDecoration(
                color: TColors.primary,
                width: 1.0,
                size: 2.0,
                radiusPadding: 25.0,
              ),
              clockNumberDecoration: TimePickerClockNumberDecoration(
                clockIncrementHourFormat: ClockIncrementHourFormat.two,
                clockIncrementTimeFormat: ClockIncrementTimeFormat.tenMin,
                defaultTextColor: isDark ? Colors.white : Colors.black,
                defaultFontSize: 16,
                clockTimeFormat: controller.clockTimeFormat,
              ),
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        // -- Time Card
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TSleepTimeWidget(
              title: 'Bed Time',
              icon: Icons.dark_mode,
              time: controller.inBedTime,
            ),
            TSleepTimeWidget(
              title: 'Woke Up',
              icon: Icons.light_mode,
              time: controller.outBedTime,
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        // -- Time asleep
        Obx(
          () => Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Time asleep ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  style: Theme.of(context).textTheme.headlineSmall,
                  text: TFormatter.formatSleepTime(
                      controller.intervalBedTime.value, true),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        // Save Button
        SizedBox(
          width: TDeviceUtils.getScreenWidth() * 0.3,
          child: ElevatedButton(
            onPressed: () => Get.back(),
            child: Text(
              'Save',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .apply(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
