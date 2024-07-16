import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../controllers/user_controller.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/validators/validation.dart';

class UsernameScreen extends StatelessWidget {
  const UsernameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: true,
        title: Text('Edit Username',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            Form(
              key: controller.userNameFormKey,
              child: TextFormField(
                controller: controller.usernameController,
                validator: (value) =>
                    TValidator.validateNickname('Nickname', value),
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_2_outlined),
                    hintText: 'Enter new nickname'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () => controller.changeUsername(),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
