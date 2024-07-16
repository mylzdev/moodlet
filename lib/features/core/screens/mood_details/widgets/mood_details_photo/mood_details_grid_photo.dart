import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/mood_controller.dart';
import '../../../../../../common/widgets/images/image_exit_button.dart';
import '../../../../../../utils/constants/sizes.dart';

class TMoodDetailsGridPhoto extends StatelessWidget {
  const TMoodDetailsGridPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MoodController.instance;
    return Obx(
      () {
        return SizedBox(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.imageList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: controller.imageList.length > 1 ? 2 : 1),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(TSizes.xs),
                child: Hero(
                  tag: 'image_${controller.imageList[index].name}',
                  child: TImageExitButton(
                    imageFile: controller.imageList[index],
                    onRemovePressed: () => controller.removeImagePopup(
                      controller.imageList[index],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
