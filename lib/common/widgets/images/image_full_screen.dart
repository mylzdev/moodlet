import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../../features/core/controllers/mood_controller.dart';
import '../../../utils/formatters/formatter.dart';
import 'package:photo_view/photo_view.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';

class TImageFullScreen extends StatelessWidget {
  const TImageFullScreen({super.key, required this.imagePath});

  final XFile imagePath;

  @override
  Widget build(BuildContext context) {
    final controller = MoodController.instance;
    return Obx(
      () => GestureDetector(
        onTap: () => controller.isAppbarVisible.value =
            !controller.isAppbarVisible.value,
        child: Container(
          height: TDeviceUtils.getScreenHeight(),
          width: TDeviceUtils.getScreenWidth(),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            children: [
              Center(
                child: Hero(
                  tag: 'image_$imagePath',
                  child: PhotoView.customChild(
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                    child: Image.file(
                      File(imagePath.path),
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        color: THelperFunctions.isDarkMode(context)
                            ? TColors.darkerGrey
                            : TColors.lightContainer,
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: controller.isAppbarVisible.value
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Container(
                  color: Colors.black.withOpacity(0.5),
                  width: TDeviceUtils.getScreenWidth(),
                  height: TDeviceUtils.getAppBarHeight() * 2,
                  padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Iconsax.arrow_left,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(bottom: TSizes.sm * 1.7),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            // Date created text
                            child: Text(
                              TFormatter.formatDate(
                                  MoodController.instance.createdAt.value),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .apply(color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                secondChild: SizedBox(
                  height: TDeviceUtils.getScreenHeight(),
                  width: TDeviceUtils.getScreenWidth(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
