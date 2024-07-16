import 'package:flutter/material.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class TCardContainer extends StatelessWidget {
  const TCardContainer({
    super.key,
    this.width,
    this.height,
    this.radius = TSizes.cardRadiusLg,
    this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(TSizes.defaultSpace),
    this.isHeading = false,
  });

  final double? width;
  final double? height;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final Color? backgroundColor;
  final bool isHeading;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor ??
            (isHeading
                ? TColors.secondary
                : isDark
                    ? TColors.darkContainer
                    : TColors.lightContainer),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: (isHeading && isDark)
                ? TColors.secondary.withAlpha(100)
                : isDark
                    ? TColors.secondary.withAlpha(100)
                    : isHeading
                        ? TColors.secondaryContainer
                        : TColors.lightShadow,
          ),
        ],
      ),
      child: child,
    );
  }
}
