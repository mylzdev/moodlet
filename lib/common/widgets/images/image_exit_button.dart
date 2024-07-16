import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../shapes/container/rounded_container.dart';
import 'image_full_screen.dart';

class TImageExitButton extends StatelessWidget {
  const TImageExitButton({
    super.key,
    this.onRemovePressed,
    this.imageFile,
  });

  final VoidCallback? onRemovePressed;
  final XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Get.to(
            () => TImageFullScreen(imagePath: imageFile!),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
              child: Center(
                child: Image.file(
                  File(imageFile!.path),
                  fit: BoxFit.cover,
                  height: double.maxFinite,
                  width: double.maxFinite,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    color: THelperFunctions.isDarkMode(context)
                        ? TColors.darkerGrey
                        : TColors.lightContainer,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              )),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: Transform.rotate(
            angle: .8,
            child: GestureDetector(
              onTap: onRemovePressed,
              child: const TRoundedContainer(
                padding: EdgeInsets.all(TSizes.xs),
                backgroundColor: TColors.secondary,
                child: Icon(
                  Iconsax.add,
                  color: TColors.error,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
