import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../common/widgets/shapes/container/card_container.dart';
import '../../../utils/constants/local_storage_key.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/logging/logger.dart';
import '../../../utils/popups/popups.dart';
import 'navigation_controller.dart';

class TutorialController extends GetxController {
  static TutorialController get instance => Get.find();

  final _localStorage = GetStorage();
  final confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  // Tutorial
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];

  // Global Keys
  final GlobalKey addMoodKey = GlobalKey();
  final GlobalKey entriesKey = GlobalKey();
  final GlobalKey statisticKey = GlobalKey();
  final GlobalKey calendaryKey = GlobalKey();
  final GlobalKey settingsKey = GlobalKey();
  final GlobalKey filterKey = GlobalKey();
  final GlobalKey refreshKey = GlobalKey();

  bool get isTutorialDone =>
      _localStorage.read(TLocalStorageKey.isTutorialDone);

  @override
  void onInit() async {
    _localStorage.writeIfNull(TLocalStorageKey.isTutorialDone, false);
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        if (!isTutorialDone) {
          showTutorialCoachMark();
        }
      },
    );
    super.onInit();
  }

  void congratsUser() {
    _localStorage.write(TLocalStorageKey.isTutorialDone, true);
    confettiController.play();
    TPopup.successSnackbar(
        title: 'Congratulations!',
        message:
            "You're all set to explore and make the most of our mood tracker app");
  }

  void showTutorialCoachMark() {
    _initTarget();
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      hideSkip: true,
      onClickTarget: (target) {
        if (target.identify == 'settings') {
          TLoggerHelper.info(target.identify);
          NavigationController.instance.navbarIndex.value = 0;
        }
      },
      onFinish: () {
        congratsUser();
      },
      onSkip: () {
        congratsUser();
        return true;
      },
    )..show(context: Get.overlayContext!);
  }

  void _initTarget() {
    targets = [
      // Add Mood
      TargetFocus(
        identify: 'add-mood',
        keyTarget: addMoodKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => TCoachMarkContent(
              text:
                  'This button is the gateway to your effortless mood tracking. With just a tap, you can log your emotions and feelings for any given day.',
              onNext: () => controller.next(),
              onSkip: () => controller.skip(),
            ),
          ),
        ],
      ),
      // Entries
      TargetFocus(
        identify: 'entries',
        keyTarget: entriesKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => TCoachMarkContent(
              text:
                  'This is your Entries or personalized feed of your mood entries giving you a comprehensive overview of your emotional journey.',
              onNext: () => controller.next(),
              onSkip: () => controller.skip(),
            ),
          ),
        ],
      ),
      // Statistic
      TargetFocus(
        identify: 'statistic',
        keyTarget: statisticKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => TCoachMarkContent(
              text:
                  'This your Statistics page offers insightful visualizations of your mood trends over time. You can explore and analyze your emotional patterns with clarity and precision.',
              onNext: () => controller.next(),
              onSkip: () => controller.skip(),
            ),
          ),
        ],
      ),
      // calendar
      TargetFocus(
        identify: 'calendar',
        keyTarget: calendaryKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => TCoachMarkContent(
              text:
                  'This is your mood Calendar offers a visual representation of your emotional journey throughout the month. Each day is marked with your recorded moods.',
              onNext: () => controller.next(),
              onSkip: () => controller.skip(),
            ),
          ),
        ],
      ),
      // settings
      TargetFocus(
        identify: 'settings',
        keyTarget: settingsKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => TCoachMarkContent(
              text:
                  'The Settings page offers a range of customizable options to enhance your experience and personalize your journey towards emotional well-being.',
              onNext: () {
                // Redirect to home screen
                NavigationController.instance.navbarIndex.value = 0;
                controller.next();
              },
              onSkip: () => controller.skip(),
            ),
          ),
        ],
      ),
      // filter
      TargetFocus(
        identify: 'filter',
        keyTarget: filterKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => TCoachMarkContent(
              text:
                  'The Mood Filter Button offers a convenient way to categorize and view your mood entries based on specific emotional states.',
              onNext: () => controller.next(),
              onSkip: () => controller.skip(),
            ),
          ),
        ],
      ),
      // refresh
      TargetFocus(
        identify: 'refresh',
        keyTarget: refreshKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => TCoachMarkContent(
              text:
                  'Lastly, the Refresh Button that provides a simple yet effective way to update and refresh your mood entries.',
              next: 'Finish',
              disableSkip: true,
              onNext: () => controller.next(),
            ),
          ),
        ],
      ),
    ];
  }
}

class TCoachMarkContent extends StatelessWidget {
  const TCoachMarkContent({
    super.key,
    required this.text,
    this.onSkip,
    this.onNext,
    this.next = 'Next',
    this.disableSkip = false,
  });

  final String text;
  final String next;
  final bool disableSkip;
  final VoidCallback? onSkip;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return TCardContainer(
      isHeading: true,
      padding: const EdgeInsets.all(TSizes.spaceBtwItems),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .apply(color: Colors.black)),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!disableSkip)
                TextButton(
                  onPressed: onSkip,
                  child: Text(
                    'Skip',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: Colors.black),
                  ),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(TSizes.xs)),
                onPressed: onNext,
                child: Text(next),
              ),
            ],
          )
        ],
      ),
    );
  }
}
