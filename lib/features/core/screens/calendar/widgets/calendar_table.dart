import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'calendar_day.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/calendar_controller.dart';

class TCalendarTable extends StatelessWidget {
  const TCalendarTable({
    super.key,
    required this.controller,
  });

  final CalendarController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = THelperFunctions.isDarkMode(context);

    final double availableHeight = MediaQuery.of(context).size.height;
    final double rowHeight = (availableHeight / 9).clamp(60.0, 90.0);
    return Obx(
      () {
          return TableCalendar(
            // Sizes
            rowHeight: rowHeight,
            daysOfWeekHeight: 20,
          
            // Date
            focusedDay: controller.selectedMonthYear.value,
            firstDay: controller.firstDay,
            lastDay: controller.lastDay,
          
            // Styling
            calendarStyle: const CalendarStyle(outsideDaysVisible: false),
            headerVisible: false,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: textTheme.labelLarge!
                  .apply(color: isDark ? Colors.white : Colors.black),
              weekendStyle: textTheme.labelLarge!
                  .apply(color: isDark ? Colors.white : Colors.black),
            ),
          
            // Custom Builders
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return TCalendarDayContainer(day: day);
              },
              todayBuilder: (context, day, focusedDay) {
                return TCalendarDayContainer(
                  day: day,
                  isToday: true,
                );
              },
            ),
          
            // Gestures
            onDaySelected: (selectedDay, focusedDay) =>
                controller.onDaySelected(selectedDay, focusedDay),
            onPageChanged: (focusedDay) =>
                controller.selectedMonthYear.value = focusedDay,
          );
        }
    );
  }
}
