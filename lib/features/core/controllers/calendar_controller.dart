import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'mood_controller.dart';
import '../../../utils/constants/local_storage_key.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/formatters/formatter.dart';
import '../../../utils/popups/popups.dart';
import '../screens/mood/mood.dart';

class CalendarController extends GetxController {
  static CalendarController get instance => Get.find();

  final _localStorage = GetStorage();
  Rx<DateTime> selectedMonthYear = DateTime.now().obs;

  DateTime today = DateTime.now();
  late DateTime firstDay;
  late DateTime lastDay;

  late FixedExtentScrollController scrollController;

  @override
  void onInit() {
    firstDay = DateTime(DateTime.parse(_localStorage.read(TLocalStorageKey.firstDay)).year, DateTime.january);
    lastDay = DateTime(today.year, today.month + 1, 0);
    super.onInit();
  }

  // Calendar Screen
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // Only past and current day is interactive
    if (selectedDay.isBefore(today)) {
      MoodController.instance.createdAt.value = selectedDay;
      Get.to(
        () => const MoodScreen(title: 'How were you?'),
        transition: Transition.downToUp,
      );
    } else {
      // Future days can't be interact
      TPopup.warningSnackbar(
        title: 'Oops',
        message: 'That day is yet to come',
      );
    }
  }

  Future<void> showMonthYearPicker() async {
    // Get the months difference since app installation until today
    int monthsDifference = getMonthsDifference(firstDay, today);

    // Temporary selected values
    DateTime tempSelectedMonthYear = selectedMonthYear.value;
    scrollController =
        FixedExtentScrollController(initialItem: selectedMonthYear.value.month - 1);

    // Method to update selected values
    void updateSelectedValues() {
      selectedMonthYear.value = tempSelectedMonthYear;
    }

    // Dialog
    await Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.all(TSizes.sm),
        actionsPadding: const EdgeInsets.all(8.0),
        // Title
        title: const Text('Select Month'),
        // Content
        content: SizedBox(
          height: 130,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 40,
            perspective: 0.005,
            diameterRatio: 1.2,
            overAndUnderCenterOpacity: 0.3,
            physics: const FixedExtentScrollPhysics(),
            controller: scrollController,
            onSelectedItemChanged: (index) {
              tempSelectedMonthYear = DateTime.utc(
                firstDay.year,
                firstDay.month + index,
              );
            },
            childDelegate: ListWheelChildBuilderDelegate(
              // +1 to include the current month since the user installed the app
              childCount: monthsDifference + 1,
              builder: (context, index) {
                DateTime displayedDate =
                    DateTime.utc(firstDay.year, firstDay.month + index);
                return Text(
                  TFormatter.formatMonthYear(
                      displayedDate.month, displayedDate.year),
                  style: Theme.of(context).textTheme.titleLarge,
                );
              },
            ),
          ),
        ),
        // Actions
        actions: [
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: Get.isDarkMode ? Colors.white : Colors.black),
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: Get.isDarkMode ? Colors.white : Colors.black),
            onPressed: () {
              updateSelectedValues();
              Get.back();
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  int getMonthsDifference(DateTime startDate, DateTime endDate) {
    return (endDate.year - startDate.year) * 12 +
        endDate.month -
        startDate.month;
  }
}
