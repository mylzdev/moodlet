import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moodlet/features/core/models/mood_model/mood_choice_model.dart';

import '../../../data/respositories/mood_repository.dart';
import '../../../utils/constants/local_storage_key.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/formatters/formatter.dart';
import '../../../utils/logging/logger.dart';
import '../../../utils/popups/popups.dart';
import '../models/mood_model/mood_model.dart';

class StatisticController extends GetxController {
  static StatisticController get instance => Get.find();
  final _localStorage = GetStorage();

  final _moodRepository = MoodRepository.instance;
  final moodCounts = <MoodCount>[].obs;
  final chartSpots = <FlSpot>[].obs;

  Rx<DateTime> selectedMonthYear = DateTime.now().obs;
  late DateTime firstDay;
  late FixedExtentScrollController scrollController;

  @override
  void onInit() {
    firstDay = DateTime(
        DateTime.parse(_localStorage.read(TLocalStorageKey.firstDay)).year,
        DateTime.january);
    getMoodCountsByDate(DateTime.now());
    super.onInit();
  }

  Future<void> getMoodCountsByDate(DateTime date) async {
    try {
      final mood = await _moodRepository.fetchMoodCountsByDate(date);
      moodCounts.assignAll(mood);
      final spots = await getMoodSpotsForMonth(date);
      chartSpots.assignAll(spots);
    } catch (e) {
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
      rethrow;
    }
  }

  /// Opens a dialog to select a month and year using a scrollable picker.
  Future<void> showMonthYearPicker() async {
    // Get the months difference since app installation until today
    int monthsDifference = getMonthsDifference(firstDay, DateTime.now());

    // Temporary selected values
    DateTime tempSelectedMonthYear = selectedMonthYear.value;
    scrollController = FixedExtentScrollController(
        initialItem: selectedMonthYear.value.month - 1);

    // Method to update selected values
    void updateSelectedValues() {
      selectedMonthYear.value = tempSelectedMonthYear;
      getMoodCountsByDate(selectedMonthYear.value);
    }

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

  /// Calculate the total difference in months between two dates.
  int getMonthsDifference(DateTime startDate, DateTime endDate) {
    return (endDate.year - startDate.year) * 12 +
        endDate.month -
        startDate.month;
  }

  /// Fetches mood data for the given month and maps it to chart spots.
  Future<List<FlSpot>> getMoodSpotsForMonth(DateTime selectedMonth) async {
    final moodData = await _moodRepository.fetchMoodsForMonth(selectedMonth);

    bool isCurrentMonth = selectedMonth.month == DateTime.now().month;
    int totalDays = isCurrentMonth
        ? DateTime.now().day
        : DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
    Map<int, double> dailyMoodValues = {};

    for (var mood in moodData) {
      final moodDate = DateTime.parse(mood.createdAt);
      final day = moodDate.day;
      final moodValue = getMoodValue(mood.moodTitle);
      dailyMoodValues[day] = moodValue.toDouble();
    }

    return List.generate(totalDays, (index) {
      double yValue = dailyMoodValues[index + 1] ?? 0;
      return FlSpot(index.toDouble() + 1, yValue);
    });
  }

  /// Convert a mood title into a corresponding numeric value.
  double getMoodValue(String moodTitle) {
    switch (moodTitle) {
      case bad:
        return 1;
      case poor:
        return 2;
      case okay:
        return 3;
      case good:
        return 4;
      case great:
        return 5;
      default:
        return 0;
    }
  }
}
