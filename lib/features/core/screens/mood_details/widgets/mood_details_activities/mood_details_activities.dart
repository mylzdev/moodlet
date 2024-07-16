import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/mood_controller.dart';
import '../../../../models/activities_model/activities_model.dart';

import '../../../../../../common/widgets/image_text/svg_text_vertical.dart';
import '../../../../../../common/widgets/card/mood_details_card.dart';

class TMoodDetailsActivities extends StatelessWidget {
  const TMoodDetailsActivities({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final activityList = ActivitiesModel.activityList;
    final controller = MoodController.instance;
    return TMoodDetailsCard(
      cardTitle: 'Activities',
      cardTontent: Center(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: activityList.length,
          itemBuilder: (context, index) {
            return Obx(
              () => GestureDetector(
                onTap: () => controller.toggleActivitiesSelection(index),
                child: TSvgTextVertical(
                  svgImage: activityList[index].activityImage,
                  title: activityList[index].activityName,
                  isSelected: controller.isActivitiesSelected(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
