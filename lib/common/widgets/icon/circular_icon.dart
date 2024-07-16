import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class TCircularIcon extends StatelessWidget {
  const TCircularIcon({
    super.key,
    this.backgroundColor,
    required this.icon,
    this.height = 50,
    this.width = 50,
  });

  final Color? backgroundColor;
  final IconData icon;
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: backgroundColor ?? TColors.primary, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white),
    );
  }
}
