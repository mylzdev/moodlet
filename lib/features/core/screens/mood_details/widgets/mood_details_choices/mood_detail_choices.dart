import 'package:flutter/material.dart';
import '../../../../models/mood_model/mood_model.dart';
import '../../../mood/widgets/mood_choices.dart';
import '../../../../../../utils/constants/sizes.dart';

import '../../../../../../common/widgets/card/mood_details_card.dart';

class TMoodDetailsChoices extends StatelessWidget {
  const TMoodDetailsChoices({super.key, this.moodData});

  final MoodModel? moodData;

  @override
  Widget build(BuildContext context) {
    return const TMoodDetailsCard(
      spaceBtw: TSizes.spaceBtwItems / 2,
      padding: EdgeInsets.all(TSizes.md),
      isHeading: true,
      cardTitle: 'Emotions',
      cardTontent: MoodChoices(
        textColor: Colors.black,
        moodSize: 50,
        useFilter: false,
        shouldFetchMood: false,
      ),
    );
  }
}
