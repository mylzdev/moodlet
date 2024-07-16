import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/statistic_controller.dart';
import 'widgets/stats_chart_widget.dart';
import 'widgets/stats_header_and_bar.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StatisticController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header & Mood bar
            TStatsHeaderAndBar(controller: controller),
            // Mood Flow
            const TStatsChart(),
          ],
        ),
      ),
    );
  }
}


