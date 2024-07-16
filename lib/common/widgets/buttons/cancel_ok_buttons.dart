import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/helper_functions.dart';

class TCancelOkButtons extends StatelessWidget {
  const TCancelOkButtons({
    super.key,
    this.onConfirm,
  });

  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
              foregroundColor: isDark ? Colors.white : Colors.black),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onConfirm,
          style: TextButton.styleFrom(
              foregroundColor: isDark ? Colors.white : Colors.black),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
