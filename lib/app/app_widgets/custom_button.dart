import 'package:flutter/material.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomButton extends StatefulWidget {
  const CustomButton(
      {super.key,
      this.loading = false,
      required this.onTap,
      required this.title,
      this.enable = true,
      this.titleWidget,
      this.textSize,
      this.color,
      this.textColor,
      this.width,
      this.height,
      this.style,
      this.border,
      this.notifier});

  final bool loading;
  final bool enable;
  final VoidCallback onTap;
  final String title;
  final Widget? titleWidget;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? textSize;
  final BoxBorder? border;
  final TextStyle? style;
  final ValueNotifier<bool>? notifier;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.loading || !widget.enable ? 0.5 : 1,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed:
            widget.loading || widget.enable == false ? () {} : widget.onTap,
        child: Container(
          width: widget.width ?? MediaQuery.of(context).size.width * 0.9,
          height: widget.height ?? 55,
          decoration: BoxDecoration(
              color: widget.color ?? Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(14),
              border: widget.border),
          child: Stack(
            children: [
              Center(
                child: widget.titleWidget ??
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: widget.style ??
                          TextStyle(
                            color: widget.textColor ?? Palette.white,
                            fontWeight: FontWeight.w500,
                            fontSize: widget.textSize ?? 16,
                          ),
                    ),
              ),
              if (widget.loading)
                Positioned(
                    right: 10,
                    top: 56 / 4,
                    child: LoadingAnimationWidget.halfTriangleDot(
                      color: Palette.white,
                      size: 20,
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
