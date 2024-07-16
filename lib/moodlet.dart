import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/core/controllers/settings_controllers/settings_controller.dart';
import 'bindings/general_bindings.dart';
import 'utils/theme/theme.dart';

class Moodlet extends StatelessWidget {
  const Moodlet({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        initialBinding: GeneralBindings(),
        themeMode: SettingsController.instance.setThemeMode(),
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const Scaffold(),
      ),
    );
  }
}
