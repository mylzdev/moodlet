import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/statistic_controller.dart';
import '../../../../../utils/formatters/formatter.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/calendar_controller.dart';

class TCalendarMonthYearPicker extends StatelessWidget {
  const TCalendarMonthYearPicker(
      {super.key, this.textColor, this.isStatistics = true});

  final Color? textColor;
  final bool isStatistics;

  @override
  Widget build(BuildContext context) {
    final calendarController = CalendarController.instance;
    final statsController = StatisticController.instance;
    return GestureDetector(
      onTap: () {
        isStatistics ? statsController.showMonthYearPicker() : calendarController.showMonthYearPicker();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => Text(
              TFormatter.formatMonthYear(
                isStatistics ? statsController.selectedMonthYear.value.month : calendarController.selectedMonthYear.value.month,
                isStatistics ? statsController.selectedMonthYear.value.year : calendarController.selectedMonthYear.value.year,
              ),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .apply(color: textColor),
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            color: textColor ??
                (THelperFunctions.isDarkMode(context)
                    ? Colors.white
                    : Colors.black),
          ),
        ],
      ),
    );
  }
}
