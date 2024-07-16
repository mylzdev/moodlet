import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/shapes/container/card_container.dart';
import '../../../controllers/settings_controllers/settings_controller.dart';
import '../../../../../utils/constants/sizes.dart';
import '../widgets/passcode_switch.dart';

class TSettingsPasscode extends StatelessWidget {
  const TSettingsPasscode({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.instance;
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: true,
        title: Text('Passcode Lock',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            TCardContainer(
              padding: const EdgeInsets.all(TSizes.md),
              width: double.maxFinite,
              child: Obx(
                () => Column(
                  children: [
                    TPasscodeSwitch(controller: controller, isPasscode: true),
                    Visibility(
                      visible: controller.togglePasscode.value,
                      child: Column(
                        children: [
                          const SizedBox(height: TSizes.spaceBtwItems),
                          TPasscodeSwitch(
                              controller: controller, isPasscode: false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
