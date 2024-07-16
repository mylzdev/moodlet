import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/helpers/helper_functions.dart';

import '../shapes/container/card_container.dart';
import '../../../utils/constants/sizes.dart';

class TMoodDetailsCard extends StatelessWidget {
  const TMoodDetailsCard({
    super.key,
    required this.cardTitle,
    required this.cardTontent,
    this.isHeading = false,
    this.padding = const EdgeInsets.only(
      bottom: TSizes.defaultSpace,
      right: TSizes.md,
      top: TSizes.md,
      left: TSizes.md,
    ),
    this.spaceBtw = TSizes.spaceBtwItems,
  });

  final String cardTitle;
  final Widget cardTontent;
  final bool isHeading;
  final EdgeInsetsGeometry padding;
  final double spaceBtw;

  @override
  Widget build(BuildContext context) {
    return TCardContainer(
      isHeading: isHeading,
      padding: padding,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cardTitle,
            style: Theme.of(context).textTheme.titleLarge!.apply(
                  color: isHeading
                      ? Colors.black
                      : THelperFunctions.isDarkMode(context)
                          ? Colors.white
                          : Colors.black,
                ),
          ).marginOnly(bottom: spaceBtw),
          cardTontent,
        ],
      ),
    ).marginOnly(bottom: TSizes.spaceBtwSections);
  }
}
