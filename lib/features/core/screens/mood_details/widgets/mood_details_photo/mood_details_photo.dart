import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/mood_controller.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../common/widgets/card/mood_details_card.dart';
import 'mood_details_grid_photo.dart';
import 'mood_details_photo_button.dart';

class TMoodDetailsPhoto extends StatelessWidget {
  const TMoodDetailsPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MoodController.instance;
    return TMoodDetailsCard(
      cardTitle: 'Insert photo',
      cardTontent: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            controller.imageList.isEmpty
                ? const Text('Maximum of 4 Images')
                : const TMoodDetailsGridPhoto(),
            const SizedBox(height: TSizes.spaceBtwItems),
            const TMoodDetailsPhotoButton(),
          ],
        ),
      ),
    );
  }
}