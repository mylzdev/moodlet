import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../controllers/settings_controllers/setting_display_mode_controller.dart';
import '../../../controllers/settings_controllers/settings_controller.dart';
import '../../../models/settings_model/display_mode_model.dart';
import '../../../../../utils/constants/sizes.dart';
import '../widgets/display_mode_card.dart';

class TSettingsDisplayMode extends StatelessWidget {
  const TSettingsDisplayMode({super.key});

  @override
  Widget build(BuildContext context) {
    final modeList = DisplayModeModel.list;
    final controller = SettingsController.instance;
    Get.put(SettingDisplayController());
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: true,
        title: Text(
          'Display Mode',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: modeList.length,
              separatorBuilder: (_, index) =>
                  const SizedBox(height: TSizes.spaceBtwItems),
              itemBuilder: (_, index) => Obx(
                () => GestureDetector(
                  onTap: () => controller.tempDisplayIndex.value = index,
                  child: TSettingsDisplayModeCard(
                    title: modeList[index].title,
                    image: modeList[index].image,
                    isSelected: index == controller.tempDisplayIndex.value,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () => controller.setSelectedDisplayModeIndex(),
          child: const Text('Apply'),
        ),
      ),
    );
  }
}
