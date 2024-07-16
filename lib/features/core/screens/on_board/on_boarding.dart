import 'package:flutter/material.dart';
import '../../../../common/widgets/shapes/container/rounded_container.dart';
import '../../controllers/user_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/validators/validation.dart';

import 'widgets/on_board_background.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: TColors.primary,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: double.maxFinite,
              child: TOnboardBackground(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace / 1.5),
            child: TRoundedContainer(
              radius: TSizes.borderRadiusLg * 1.5,
              width: double.maxFinite,
              height: 300,
              backgroundColor: TColors.lightContainer,
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace / 1.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text(
                      'Welcome',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: TColors.black),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Text(
                      'What do you want me to call you?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: TColors.black),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems * 2),
                    Form(
                      key: controller.userNameFormKey,
                      child: TextFormField(
                        controller: controller.usernameController,
                        validator: (value) => TValidator.validateNickname('Nickname', value),
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Enter your nickname',
                          errorStyle: const TextStyle(color: TColors.error),
                          hintStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.all(20),
                          filled: true,
                          fillColor: TColors.grey,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.inputFieldRadius),
                            borderSide: BorderSide.none,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.inputFieldRadius),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.inputFieldRadius),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.inputFieldRadius),
                            borderSide: BorderSide.none,
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.inputFieldRadius),
                            borderSide: BorderSide.none,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.inputFieldRadius),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    SizedBox(
                      height: 60,
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () => controller.signup(),
                        child: const Text('Continue'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


