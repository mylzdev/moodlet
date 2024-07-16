import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../shimmer/shimmer_effect.dart';

class TCircularImage extends StatelessWidget {
  const TCircularImage({
    super.key,
    this.width = 30,
    this.height = 30,
    this.isNetworkImage = false,
    required this.image,
    this.backgroundColor = Colors.transparent,
    this.overlayColor,
    this.fit = BoxFit.cover,
  });

  final double width, height;
  final BoxFit? fit;
  final bool isNetworkImage;
  final String image;
  final Color? backgroundColor, overlayColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      // customize the size of image using padding the higher the smaller size
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: isNetworkImage
              ? CachedNetworkImage(
                  fit: fit,
                  color: overlayColor,
                  imageUrl: image,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  progressIndicatorBuilder: (context, url, progress) =>
                      TShimmerEffect(width: width, height: width),
                )
              : Image(
                  image: AssetImage(image),
                  color: overlayColor,
                  fit: fit,
                ),
        ),
      ),
    );
  }
}
