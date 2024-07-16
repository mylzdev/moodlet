import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';

class TActionBarItem extends StatelessWidget {
  const TActionBarItem({
    super.key,
    required this.bgColor,
    required this.text,
    this.onPressed,
    required this.icon,
  });

  final Color bgColor;
  final String text;
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Text(text, style: const TextStyle(color: Colors.white)),
          const SizedBox(width: TSizes.sm),
          Container(
            padding: const EdgeInsets.all(TSizes.sm),
            decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd)),
            child: Icon(icon),
          )
        ],
      ),
    );
  }
}
