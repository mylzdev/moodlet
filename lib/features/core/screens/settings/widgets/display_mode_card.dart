import 'package:flutter/material.dart';

import '../../../../../common/widgets/shapes/container/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TSettingsDisplayModeCard extends StatelessWidget {
  const TSettingsDisplayModeCard({
    super.key,
    required this.title,
    this.image = '',
    this.isSelected = false,
  });

  final String title, image;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Opacity(
      opacity: isSelected ? 1 : 0.8,
      child: TRoundedContainer(
        showBorder: true,
        padding: const EdgeInsets.all(TSizes.sm),
        borderColor: isSelected
            ? TColors.primary
            : isDark
                ? TColors.darkerGrey
                : TColors.grey,
        child: Row(
          children: [
            Stack(
              children: [
                TRoundedContainer(
                  height: 130,
                  width: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                    child: Image.asset(image, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(title, style: Theme.of(context).textTheme.headlineSmall)
          ],
        ),
      ),
    );
  }
}
