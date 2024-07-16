import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/mood_controller.dart';
import '../../controllers/quote_controller.dart';
import '../../controllers/tutorial_controller.dart';
import 'widgets/home_appbar.dart';
import 'widgets/home_back_to_top.dart';
import 'widgets/home_body.dart';
import 'widgets/home_quote.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(QuoteController(), permanent: true);
    final homeController = HomeController.instance;
    final moodController = MoodController.instance;
    final tutorialController = TutorialController.instance;
    return Scaffold(
      appBar: THomeAppbar(
        tutorialController: tutorialController,
        homeController: homeController,
        moodController: moodController,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          NestedScrollView(
            controller: homeController.scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                const THomeQuote(),
              ];
            },
            body: THomeBody(moodController: moodController),
          ),
          THomeBackToTop(homeController: homeController),
          ConfettiWidget(
            numberOfParticles: 20,
            blastDirectionality: BlastDirectionality.explosive,
            confettiController: tutorialController.confettiController,
          ),
        ],
      ),
    );
  }
}
