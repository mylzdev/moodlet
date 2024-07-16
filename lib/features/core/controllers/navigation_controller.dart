import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'mood_controller.dart';
import '../screens/mood/mood.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/popups/popups.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../screens/calendar/calendar.dart';
import '../screens/home/home.dart';
import '../screens/settings/settings.dart';
import '../screens/statistics/stats.dart';

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();

  final navbarIndex = 0.obs;
  final moodController = MoodController.instance;

  final iconList = [
    Iconsax.home,
    Iconsax.activity,
    Iconsax.calendar,
    Iconsax.user,
  ];

  final screens = [
    const HomeScreen(),
    const StatisticsScreen(),
    const CalendarScreen(),
    const SettingsScreen(),
  ];

  Future<void> showDatePicker(DateTime? initialDay) async {
    try {
      moodController.createdAt.value =
          await THelperFunctions.toggleDatePicker(initialDay);

      if (moodController.createdAt.value!.isBefore(DateTime.now())) {
        Get.to(
          () => MoodScreen(
              title: 'How were you?',
              isDateInteractable: true,
              onPressed: () async => reShowDatePicker()),
          transition: Transition.downToUp,
        );
      } else {
        TPopup.warningSnackbar(
            title: TTexts.ohSnap, message: 'That day is yet to come');
      }
    } catch (_) {}
  }

  Future<void> reShowDatePicker() async {
    try {
      moodController.createdAt.value = await THelperFunctions.toggleDatePicker(
          moodController.createdAt.value);
      moodController.createdAt.value = moodController.createdAt.value;
    } catch (_) {}
  }
}
