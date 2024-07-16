import 'package:flutter/material.dart';

import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class TStylishContainer extends StatelessWidget {
  const TStylishContainer({
    super.key,
    this.padding = TSizes.md,
    this.borderRadius = TSizes.cardRadiusLg,
    this.width,
    this.height,
    required this.containerColor,
    required this.child,
  });

  final Widget child;
  final ContainerColor containerColor;
  final double padding, borderRadius;
  final double? width, height;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: containerColor == ContainerColor.blue
            ? const Color(0xFFDCEDF9)
            : containerColor == ContainerColor.pink
                ? const Color(0xFFFDD6CE)
                : containerColor == ContainerColor.green
                    ? const Color(0xFFE9F9DC)
                    : const Color(0xFFFCEDCA),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: isDark
                // Dark theme
                ? containerColor == ContainerColor.blue
                    ? const Color(0xFFDCEDF9).withAlpha(100)
                    : containerColor == ContainerColor.pink
                        ? const Color(0xFFFDD6CE).withAlpha(100)
                        : containerColor == ContainerColor.green
                            ? const Color(0xFFE9F9DC).withAlpha(100)
                            : const Color(0xFFFCEDCA).withAlpha(100)
                // Light theme
                : containerColor == ContainerColor.blue
                    ? const Color.fromARGB(255, 62, 99, 125).withAlpha(100)
                    : containerColor == ContainerColor.pink
                        ? const Color.fromARGB(255, 104, 60, 60).withAlpha(100)
                        : containerColor == ContainerColor.green
                            ? const Color.fromARGB(255, 78, 106, 55).withAlpha(100)
                            : const Color.fromARGB(255, 105, 90, 54).withAlpha(100),
          )
        ],
      ),
      child: child,
    );
  }
}
