import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../curved_edges/curve_edges_widget.dart';
import 'rounded_container.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgeWidget(
      child: Container(
        color: TColors.secondary,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
              top: -150,
              right: -250,
              child: TRoundedContainer(
                width: 400,
                height: 400,
                radius: 400,
                backgroundColor: TColors.primary.withOpacity(0.15),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: TRoundedContainer(
                width: 400,
                height: 400,
                radius: 400,
                backgroundColor: TColors.primary.withOpacity(0.15),
              ),
            ),
            Container(
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
