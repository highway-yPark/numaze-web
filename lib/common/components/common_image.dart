import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommonImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CommonImage({
    super.key,
    required this.imageUrl,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      // placeholder: (context, url) => SvgPicture.asset(
      //   'assets/images/landscape-placeholder.svg',
      //   width: width,
      //   height: height,
      //   fit: fit,
      // ),
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        width: width,
        height: height,
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fadeOutDuration: const Duration(milliseconds: 300),
      fadeInDuration: const Duration(milliseconds: 300),
      width: width,
      height: height,
      fit: fit,
      cacheKey: imageUrl,
    );
  }
}
