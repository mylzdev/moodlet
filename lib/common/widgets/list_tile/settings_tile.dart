import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/helpers/helper_functions.dart';

class TSettingsTile extends StatelessWidget {
  const TSettingsTile({
    super.key,
    this.title,
    this.leadingIcon,
    this.trailingIcon = Iconsax.arrow_right,
    this.onPresed,
  });

  final String? title;
  final IconData? leadingIcon, trailingIcon;
  final VoidCallback? onPresed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPresed,
      child: ListTile(
        enabled: false,
        leading: Icon(
          leadingIcon,
          color: THelperFunctions.isDarkMode(context)
              ? Colors.white
              : Colors.black,
        ),
        title: Text(title!, style: Theme.of(context).textTheme.titleMedium),
        trailing: Icon(
          trailingIcon,
          color: THelperFunctions.isDarkMode(context)
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}
