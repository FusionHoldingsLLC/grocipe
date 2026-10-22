import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgRenderWidget extends StatelessWidget {
  final String svgPath;
  final double? height;
  final double? width;
  final Color? color;
  final VoidCallback? onTap;

  const SvgRenderWidget({
    super.key,
    this.width,
    this.height,
    this.color,
    required this.svgPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        svgPath,
        color: color,
        height: height,
        width: width,
      ),
    );
  }
}
