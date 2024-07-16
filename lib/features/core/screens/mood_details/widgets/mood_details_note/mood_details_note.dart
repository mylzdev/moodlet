import 'package:flutter/material.dart';
import '../../../../controllers/mood_controller.dart';
import '../../../../../../common/widgets/card/mood_details_card.dart';

class TMoodDetailsNote extends StatelessWidget {
  const TMoodDetailsNote({super.key});

  @override
  Widget build(BuildContext context) {
    return TMoodDetailsCard(
      cardTitle: 'Quick note',
      cardTontent: TextField(
        controller: MoodController.instance.note,
        decoration: const InputDecoration(
          hintText: 'Write here',
        ),
      ),
    );
  }
}
