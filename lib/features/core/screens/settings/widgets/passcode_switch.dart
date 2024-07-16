import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/shapes/container/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/settings_controllers/settings_controller.dart';

class TPasscodeSwitch extends StatelessWidget {
  const TPasscodeSwitch({
    super.key,
    required this.controller,
    required this.isPasscode,
  });

  final SettingsController controller;
  final bool isPasscode;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TRoundedContainer(
          padding: const EdgeInsets.symmetric(
              horizontal: TSizes.md, vertical: TSizes.sm),
          backgroundColor: THelperFunctions.isDarkMode(context)
              ? TColors.dark
              : TColors.darkSoftGrey,
          child: Text(
            isPasscode ? 'Set up passcode' : 'Enable Fingerprint',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Obx(
          () => Switch.adaptive(
              activeColor: THelperFunctions.isDarkMode(context)
                  ? TColors.secondary
                  : TColors.primary,
              value: isPasscode
                  ? controller.togglePasscode.value
                  : controller.toggleFingerprint.value,
              onChanged: (value) => isPasscode
                  ? controller.enablePasscode(value, context)
                  : controller.enableFingerprint(value)),
        )
      ],
    );
  }
}