import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';
import 'quote_widget.dart';

class THomeQuote extends StatelessWidget {
  const THomeQuote({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      floating: true,
      toolbarHeight: 20,
      expandedHeight: 145,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(
            left: TSizes.defaultSpace,
            right: TSizes.defaultSpace,
            top: TSizes.sm,
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              SizedBox(height: TSizes.spaceBtwItems),
              TQuote(),
            ],
          ),
        ),
      ),
    );
  }
}
