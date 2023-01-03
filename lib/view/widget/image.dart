import 'package:cached_network_image/cached_network_image.dart';
import 'package:careAsOne/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CircularCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final double loaderWidth;
  final Color bgColor;
  final Color? iconColor;

  CircularCachedImage({
    this.imageUrl,
    this.radius = 20.0,
    this.loaderWidth = 1.0,
    this.bgColor = AppColors.bgGreen,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => CircleAvatar(
          radius: radius,
          backgroundColor: bgColor,
          child: CircularProgressIndicator(strokeWidth: loaderWidth)),
      errorWidget: (context, url, error) => CircleAvatar(
          radius: radius,
          backgroundColor: bgColor,
          backgroundImage: NetworkImage(
              "https://www.pngitem.com/pimgs/m/421-4212617_person-placeholder-image-transparent-hd-png-download.png")),
    );
  }
}

class RectangularCachedImage extends StatelessWidget {
  final double height;
  final String imageUrl;
  final BoxFit fit;

  RectangularCachedImage(
      {required this.height,required this.imageUrl, this.fit = BoxFit.fitHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator(color: Colors.green,)),
        errorWidget: (context, url, error) =>
            Icon(Icons.image_not_supported_outlined),
      ),
    );
  }
}
