import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/helper/constants/svg_path.dart';

class ImageRenderWidget extends StatelessWidget {
  static const header = <String, String>{};

  const ImageRenderWidget._({
    this.imageUrl,
    required this.height,
    required this.width,
    this.imagePath,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.file,
    this.memoryImage,
  })  : assert(imagePath == null || imageUrl == null,
            "You can't pass both image path and image url"),
        assert(file == null || imageUrl == null,
            "You can't pass both file and image url"),
        assert(memoryImage == null || imageUrl == null,
            "You can't pass both memory image and image url");
  final String? imageUrl;
  final double? height;
  final double? width;
  final Widget? placeholder;
  final BoxFit fit;
  final String? imagePath;
  final File? file;
  final Uint8List? memoryImage; // Memory image property

  factory ImageRenderWidget.asset({
    required String imagePath,
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
  }) =>
      ImageRenderWidget._(
        imagePath: imagePath,
        height: height,
        width: width,
        fit: fit,
      );

  factory ImageRenderWidget.file({
    required File file,
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
  }) =>
      ImageRenderWidget._(
        height: height,
        width: width,
        fit: fit,
        file: file,
      );

  factory ImageRenderWidget.network({
    required String? imageUrl,
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
  }) =>
      ImageRenderWidget._(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        placeholder: placeholder,
      );

  factory ImageRenderWidget.memory({
    required Uint8List memoryImage,
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
  }) =>
      ImageRenderWidget._(
        memoryImage: memoryImage,
        height: height,
        width: width,
        fit: fit,
      );

  @override
  Widget build(BuildContext context) {
    const placeholderMain = CupertinoActivityIndicator();

    var defaultPlaceHolder = SvgRenderWidget(
      svgPath: SvgPath.star,
      width: width,
      height: height,
    );

    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        fit: fit,
        width: width,
        height: height,
      );
    }
    if (file != null) {
      return Image.file(
        file!,
        fit: fit,
        width: width,
        height: height,
      );
    }
    if (memoryImage != null) {
      return Image.memory(
        memoryImage!,
        fit: fit,
        width: width,
        height: height,
      );
    }
    if (imageUrl == null) return defaultPlaceHolder;
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      httpHeaders: header,
      placeholder: (_, __) => placeholder ?? placeholderMain,
      errorWidget: (_, __, ___) => placeholder ?? defaultPlaceHolder,
    );
  }

  static ImageProvider imageProvider(String imageUrl,
          {int? maxHeight, int? maxWidth}) =>
      CachedNetworkImageProvider(
        imageUrl,
        headers: header,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
      );
}
