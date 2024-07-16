import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../controllers/mood_controller.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/formatters/formatter.dart';

import 'widgets/mood_choices.dart';

class MoodScreen extends StatelessWidget {
  const MoodScreen({
    super.key,
    this.title,
    this.onPressed,
    this.isDateInteractable = false,
    this.showBackArrow = true,
  });

  final String? title;
  final VoidCallback? onPressed;
  final bool? isDateInteractable;
  final bool? showBackArrow;

  @override
  Widget build(BuildContext context) {
    Get.put(TempController());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: TAppbar(
        showBackArrow: showBackArrow!,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Center(
                child: Text(
                  title ?? 'How are you today?',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ).marginOnly(
                  top: TSizes.spaceBtwSections * 2,
                  bottom: TSizes.spaceBtwItems),
              GestureDetector(
                onTap: onPressed,
                child: Obx(
                  // Other day
                  () => Text(
                    TFormatter.formatDate(
                        MoodController.instance.createdAt.value),
                    style: Theme.of(context).textTheme.titleMedium!.apply(
                          decoration: isDateInteractable!
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections * 4),
              const MoodChoices(useFilter: true),
            ],
          ),
        ),
      ),
    );
  }
}

class TempController extends GetxController {
  @override
  void onClose() {
    MoodController.instance.clearFieldsAndSelection();
    super.onClose();
  }
}
