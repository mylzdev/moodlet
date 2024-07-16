import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/mood_controller.dart';
import '../../../../models/emotion_model/emotion_model.dart';
import '../../../../../../common/widgets/card/mood_details_card.dart';
import '../../../../../../common/widgets/image_text/svg_text_vertical.dart';

class TMoodDetailsEmotions extends StatelessWidget {
  const TMoodDetailsEmotions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final emotionList = EmotionModel.emotionList;
    final controller = MoodController.instance;
    return TMoodDetailsCard(
      cardTitle: 'Emotions',
      cardTontent: Center(
          child: GridView.builder(
        itemCount: emotionList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (context, index) => Obx(
          () => GestureDetector(
            onTap: () => controller.toggleEmotionSelection(index),
            child: TSvgTextVertical(
              svgImage: emotionList[index].emotionImage,
              title: emotionList[index].emotionName,
              isSelected: controller.isEmotionSelected(index),
            ),
          ),
        ),
      )),
    );
  }
}