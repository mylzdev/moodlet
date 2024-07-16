import 'package:get/get.dart';
import 'package:moodlet/features/core/controllers/navigation_controller.dart';
import '../data/respositories/mood_repository.dart';
import '../data/services/backup_restore_service.dart';
import '../features/core/controllers/calendar_controller.dart';
import '../features/core/controllers/home_controller.dart';
import '../features/core/controllers/mood_controller.dart';
import '../features/core/controllers/statistic_controller.dart';

import '../data/services/auth_service.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MoodRepository());
    Get.put(StatisticController());
    Get.put(MoodController());
    Get.put(CalendarController());
    Get.put(NavigationController());
    Get.put(HomeController());
    Get.putAsync<AuthenticationService>(() async => AuthenticationService());
    Get.putAsync<BackupRestoreService>(() async => BackupRestoreService());
  }
}