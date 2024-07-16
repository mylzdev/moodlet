import 'package:flutter/material.dart';
import '../../../../controllers/mood_controller.dart';
import '../../../../../../utils/constants/sizes.dart';

class TMoodDetailsPhotoButton extends StatelessWidget {
  const TMoodDetailsPhotoButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = MoodController.instance;
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: controller.pickSingleImageFromCamera,
            child: const Text('Take Photo'),
          ),
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        Expanded(
          child: ElevatedButton(
            onPressed: controller.pickMultipleImagesFromGallery,
            child: const Text('From Gallery'),
          ),
        ),
      ],
    );
  }
}
