import 'package:flutter/material.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../common/widgets/list_tile/custom_tile.dart';
import '../../../../../utils/constants/image_strings.dart';

class TSettingsContactUs extends StatelessWidget {
  const TSettingsContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: true,
        title: Text('Contact Us',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            TCustomListTile(
              title: 'Facebook',
              svgIcon: TImages.facebook,
              onPressed: () async => await THelperFunctions.launchLink(TTexts.facebookLink),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            TCustomListTile(
              title: 'Instagram',
              svgIcon: TImages.instagram,
              onPressed: () async => await THelperFunctions.launchLink(TTexts.instagramLink),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),

            TCustomListTile(
              title: 'Twitter',
              svgIcon: TImages.twitter,
              onPressed: () async => await THelperFunctions.launchLink(TTexts.twitterLink),
            ),
          ],
        ),
      ),
    );
  }
}
