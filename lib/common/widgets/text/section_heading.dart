import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../shapes/container/rounded_container.dart';

class TSectionHeading extends StatelessWidget {
  const TSectionHeading({
    super.key,
    required this.title,
    this.trailingText,
    this.hasTrailing = false,
    this.titleColor,
    this.backgroundColor,
    this.primaryBackgroundColor,
    this.padding,
  });

  final String title;
  final Color? titleColor, backgroundColor, primaryBackgroundColor;
  final String? trailingText;
  final bool hasTrailing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TRoundedContainer(
          backgroundColor: primaryBackgroundColor,
          padding: padding,
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall!.apply(
                color: titleColor ??
                    (THelperFunctions.isDarkMode(context)
                        ? Colors.white
                        : Colors.black)),
          ),
        ),
        if (hasTrailing)
          TRoundedContainer(
            padding: const EdgeInsets.symmetric(
                vertical: TSizes.xs, horizontal: TSizes.sm),
            backgroundColor: backgroundColor ??
                (THelperFunctions.isDarkMode(context)
                    ? TColors.darkContainer
                    : TColors.lightContainer),
            child: Text(
              trailingText!,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
      ],
    );
  }
}
