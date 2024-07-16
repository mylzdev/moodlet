import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/helpers/helper_functions.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/home_controller.dart';

class THomeBackToTop extends StatelessWidget {
  const THomeBackToTop({
    super.key,
    required this.homeController,
  });

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeController.isVisible.value
          ? Positioned(
              bottom: kBottomNavigationBarHeight + 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: THelperFunctions.isDarkMode(context)
                        ? TColors.lightContainer.withOpacity(0.2)
                        : TColors.darkContainer.withOpacity(0.2),
                    side: BorderSide.none),
                onPressed: () => homeController.backToTop(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                  child: Text('Back to top',
                      style: Theme.of(context).textTheme.titleLarge!.apply(color: Colors.white)),
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
