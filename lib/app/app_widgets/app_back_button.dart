// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/utils/context_extension.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? color;
  final bool center;
  const AppBackButton({super.key, this.onTap, this.color, this.center = true});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final child = InkWell(
      onTap: onTap ??
          () {
            context.pop();
          },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chevron_left_rounded,
              color: color ?? context.colors.black,
              size: 25,
            ),
          ],
        ),
      ),
    );

    return center ? Center(child: child) : child;
  }
}
