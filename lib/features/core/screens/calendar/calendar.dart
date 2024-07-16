import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../controllers/calendar_controller.dart';
import '../../../../common/widgets/buttons/mood_filter_button.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/mood_controller.dart';
import '../../../../utils/constants/sizes.dart';
import 'widgets/calendar_month_year_picker.dart';
import 'widgets/calendar_table.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = HomeController.instance;
    final controller = Get.put(CalendarController());
    return Scaffold(
      // Appbar
      appBar: TAppbar(
        title: MoodFilterButton(
            onPressed: () => homeController.isMoodFilterPressed.value =
                !homeController.isMoodFilterPressed.value),
        actions: [
          Obx(() =>
            IconButton(
              onPressed: () {
                MoodController.instance.fetchAllMoods();
              },
              icon: MoodController.instance.isFetchingLoading.value ? const CircularProgressIndicator.adaptive() : const Icon(Iconsax.refresh),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const TCalendarMonthYearPicker(isStatistics: false),
            const SizedBox(height: TSizes.spaceBtwItems),
            TCalendarTable(controller: controller),
          ],
        ),
      ),
    );
  }
}
