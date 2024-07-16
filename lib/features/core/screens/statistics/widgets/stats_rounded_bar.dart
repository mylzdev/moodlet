import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoundedBar extends StatelessWidget {
  const RoundedBar({super.key, required this.color, required this.moodCount});

  final Color color;
  final RxInt moodCount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: moodCount.value,
      child: Container(
        color: color,
      ),
    );
  }
}