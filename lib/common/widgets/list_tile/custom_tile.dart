import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../../../utils/constants/sizes.dart';
import '../shapes/container/card_container.dart';

class TCustomListTile extends StatelessWidget {
  const TCustomListTile({
    super.key,
    required this.title,
    required this.svgIcon,
    this.onPressed,
  });

  final String title;
  final String svgIcon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TouchRippleEffect(
      onTap: onPressed,
      height: 65,
      borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      rippleColor: Colors.white30,
      child: TCardContainer(
        padding: const EdgeInsets.all(TSizes.spaceBtwItems),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(svgIcon, width: TSizes.iconMd),
                const SizedBox(width: TSizes.spaceBtwItems),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const Icon(Iconsax.arrow_right),
          ],
        ),
      ),
    );
  }
}
