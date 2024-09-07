import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class TAppbar extends StatelessWidget implements PreferredSizeWidget {
  const TAppbar({
    super.key,
    this.showBackArrow = false,
    this.title,
    this.actions,
    this.backgroundColor = Colors.transparent,
    this.showBackground = false,
    this.spaceFromTop = 0,
    this.leadingWidget,
    this.leadingWidth,
    this.centerTitle = false,
  });

  final Widget? title;
  final List<Widget>? actions;
  final Widget? leadingWidget;
  final bool showBackArrow, showBackground;
  final bool? centerTitle;
  final Color? backgroundColor;
  final double spaceFromTop;
  final double? leadingWidth;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: TSizes.md,
        vertical: spaceFromTop,
      ),
      child: AppBar(
        centerTitle: centerTitle,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark),
        automaticallyImplyLeading: false,
        leadingWidth: leadingWidth,
        leading: showBackArrow
            // Background color
            ? IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Iconsax.arrow_left,
                  color: isDark ? TColors.grey : TColors.black,
                ),
              )
            : leadingWidget,
        title: title,
        actions: actions,
        backgroundColor:
            backgroundColor, // Ensure backgroundColor is set correctly
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
