import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ValueNotifier<bool>? notifier;
  final Color? color;
  final ButtonStyle? style;
  const AppElevatedButton({
    super.key,
    this.onPressed,
    required this.child,
    required this.notifier,
    this.style,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: ValueListenableBuilder(
        valueListenable: notifier ?? ValueNotifier(false),
        builder: (_, value, __) => value
            ? CupertinoActivityIndicator(color: color ?? Colors.white)
            : child,
      ),
    );
  }
}
