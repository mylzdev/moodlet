import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/settings_controllers/settins_photo_gallery_controller.dart';

class TSettingsPhotoGallery extends StatelessWidget {
  const TSettingsPhotoGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PhotoGalleryController());
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: true,
        title: Text('Photo Gallery',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Obx(
                () => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: controller.images.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () =>
                          controller.openGallery(controller.images, index),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(TSizes.cardRadiusSm),
                        child: Padding(
                          padding: const EdgeInsets.all(TSizes.xs),
                          child: Obx(
                            () => Image.file(
                              File(controller.images[index]),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
