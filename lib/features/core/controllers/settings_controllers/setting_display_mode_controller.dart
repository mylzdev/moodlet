import 'package:get/get.dart';
import 'settings_controller.dart';

class SettingDisplayController extends GetxController {
  static SettingDisplayController get instance => Get.find();

  final settingController = SettingsController.instance;

  @override
  void onClose() {
    settingController.tempDisplayIndex.value =
        settingController.selectedDisplayModeIndex.value;
    super.onClose();
  }
}
