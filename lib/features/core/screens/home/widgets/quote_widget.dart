import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/shapes/container/card_container.dart';
import '../../../controllers/user_controller.dart';
import '../../../controllers/quote_controller.dart';
import '../../../../../utils/constants/sizes.dart';

class TQuote extends StatelessWidget {
  const TQuote({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = QuoteController.instance;
    final user = UserController.instance;
    return TCardContainer(
      padding: const EdgeInsets.all(TSizes.md),
      isHeading: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${controller.dynamicGreet.value}, ${user.userName.capitalize}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .apply(color: Colors.black)),
          Obx(
            () => Text(
              controller.quote.value,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .apply(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
