import 'package:flutter/material.dart';

import '../../../../../utils/constants/image_strings.dart';

class TOnboardBackground extends StatelessWidget {
  const TOnboardBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: -30,
          left: -60,
          child: Container(
            width: 350,
            height: 350,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(10, 255, 255, 255),
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 380,
          child: Container(
            width: 75,
            height: 75,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(10, 255, 255, 255),
            ),
          ),
        ),
        Positioned(
          top: 430,
          right: -60,
          child: Container(
            width: 350,
            height: 350,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(10, 255, 255, 255),
            ),
          ),
        ),
        Positioned(
          top: 200,
          child: Image.asset(
            TImages.welcome,
            width: 300,
          ),
        ),
      ],
    );
  }
}