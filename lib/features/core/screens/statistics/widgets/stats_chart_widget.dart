import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/settings_controllers/settings_controller.dart';
import '../../../controllers/statistic_controller.dart';

class TStatsChart extends StatelessWidget {
  const TStatsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: AspectRatio(
        aspectRatio: 1.23,
        child: Column(
          children: [
            Text('Mood Flow', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: TSizes.spaceBtwSections),
            Expanded(
              child: Obx(
                () => LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 5,
                    lineBarsData: lineBarsData1,
                    titlesData: titlesData1,
                    gridData: gridData,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: TColors.secondary,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((touchedSpot) {
                            final day = touchedSpot.x.toInt();
                            return LineTooltipItem(
                              'Day $day',
                              const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border.symmetric(
                        horizontal: BorderSide(color: TColors.darkerGrey),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Line Bars Data

List<LineChartBarData> get lineBarsData1 => [
      lineChartBarData1_1,
    ];

LineChartBarData get lineChartBarData1_1 => LineChartBarData(
      color: TColors.primary,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            TColors.primary.withOpacity(0.5),
            TColors.primary.withOpacity(0.1)
          ],
        ),
      ),
      spots: StatisticController.instance.chartSpots,
    );

// Sides Titles Data

FlTitlesData get titlesData1 => FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: bottomTitles(),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(
        sideTitles: leftTitles(),
      ),
    );

// Grid Data

FlGridData get gridData => FlGridData(
      show: true,
      horizontalInterval: 1,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) =>
          const FlLine(strokeWidth: 1, color: TColors.darkerGrey),
    );

// Bottom Titles
SideTitles bottomTitles() => SideTitles(
      showTitles: true,
      interval: 3.1,
      getTitlesWidget: (value, meta) => SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(
          '${value.toInt()}',
        ),
      ),
    );

// Left Titles

Widget leftTitleWidgets(double value, TitleMeta meta) {
  final mood = SettingsController.instance.getEmoticonsTheme();
  String image;
  switch (value.toInt()) {
    case 0:
      image = THelperFunctions.isDarkMode(Get.context!)
          ? TImages.moodlessDark
          : TImages.moodlessLight;
      break;
    case 1:
      image = mood[4].moodImage;
      break;
    case 2:
      image = mood[3].moodImage;
      break;
    case 3:
      image = mood[2].moodImage;
      break;
    case 4:
      image = mood[1].moodImage;
      break;
    case 5:
      image = mood[0].moodImage;
      break;
    default:
      return Container();
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Padding(
      padding: const EdgeInsets.only(right: TSizes.xs),
      child: Image.asset(image, height: 25, width: 25),
    ),
  );
}

SideTitles leftTitles() => const SideTitles(
      getTitlesWidget: leftTitleWidgets,
      showTitles: true,
      interval: 1,
      reservedSize: 40,
    );
