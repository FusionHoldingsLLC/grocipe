import 'package:flutter/material.dart';
import 'package:grocipe/helper/utils/context_extension.dart';

class AppInputField extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final Widget child;
  const AppInputField(
      {super.key, this.title, required this.child, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: subTitle != null ? 4 : 0),
              child: Text(title ?? "", style: context.textTheme.titleMedium),
            ),
            if (subTitle != null)
              Text("  $subTitle" ?? "",
                  style: context.textTheme.titleLarge
                      ?.copyWith(color: context.colors.red)),
          ],
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}

class AppBorderInputField extends StatelessWidget {
  final String? title;
  final Widget child;
  const AppBorderInputField({super.key, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title ?? "", style: context.textTheme.titleMedium),
        const SizedBox(height: 4),
        Container(
            decoration: BoxDecoration(
                border:
                    Border.all(color: context.colors.greyOutline, width: 1.5),
                borderRadius: BorderRadius.circular(8)),
            child: child),
      ],
    );
  }
}
