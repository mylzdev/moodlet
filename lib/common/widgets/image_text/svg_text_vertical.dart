import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../shapes/container/rounded_container.dart';

class TSvgTextVertical extends StatelessWidget {
  const TSvgTextVertical({
    super.key,
    this.title,
    required this.svgImage,
    this.width = TSizes.iconLg,
    this.height = TSizes.iconLg,
    this.padding = TSizes.sm,
    this.margin,
    this.isSelected = false,
  });

  final String? title;
  final String svgImage;
  final double? width, height;
  final double padding;
  final EdgeInsetsGeometry? margin;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      margin: margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TRoundedContainer(
            backgroundColor: isDark ? TColors.darkGrey : TColors.darkSoftGrey,
            padding: EdgeInsets.all(padding),
            radius: 100,
            child: SvgPicture.asset(
              svgImage,
              width: width,
              height: height,
              colorFilter: ColorFilter.mode(
                isDark ? TColors.darkGrey : TColors.darkSoftGrey,
                isSelected! ? BlendMode.dst : BlendMode.color,
              ),
            ),
          ).marginOnly(bottom: TSizes.xs),
          title != null
              ? SizedBox(
                  width: 65,
                  child: Text(
                    title ?? '',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
