import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/dimensions.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ??
          Container(
            width: width,
            height: height,
            color: AppColors.divider,
            child: const Center(
              child: SizedBox(
                width: AppDimensions.iconMd,
                height: AppDimensions.iconMd,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Container(
            width: width,
            height: height,
            color: AppColors.divider,
            child: const Icon(
              Icons.broken_image_outlined,
              color: AppColors.textSecondary,
            ),
          ),
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }
}
