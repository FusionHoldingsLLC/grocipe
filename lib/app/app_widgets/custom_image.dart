import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImageNetwork extends StatefulWidget {
  const CustomImageNetwork(
      {super.key,
      required this.imageUrl,
      this.errorWidget,
      this.placholder,
      this.fit});
  final String imageUrl;
  final Widget? errorWidget;
  final Widget? placholder;
  final BoxFit? fit;
  @override
  State<CustomImageNetwork> createState() => _CustomImageNetworkState();
}

class _CustomImageNetworkState extends State<CustomImageNetwork> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      placeholder: (context, url) =>
          widget.placholder ?? const CircularProgressIndicator(),
      errorWidget: (context, url, error) =>
          widget.errorWidget ?? const Icon(Icons.error),
      fit: widget.fit,
    );
  }
}
