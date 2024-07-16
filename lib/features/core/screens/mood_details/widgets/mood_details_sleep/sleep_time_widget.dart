import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:progressive_time_picker/progressive_time_picker.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';

class TSleepTimeWidget extends StatelessWidget {
  const TSleepTimeWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.time,
  });

  final String title;
  final IconData icon;
  final Rx<PickedTime> time;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? TColors.darkContainer : TColors.lightContainer,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Obx(
          () => Column(
            children: [
              Text(time.value.h >= 12 ? 'PM' : 'AM'),
              Text(
                '${intl.NumberFormat('00').format(time.value.h % 12 == 0 ? 12 : time.value.h % 12)} : ${intl.NumberFormat('00').format(time.value.m)}m',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Icon(icon),
            ],
          ),
        ),
      ),
    );
  }
}
