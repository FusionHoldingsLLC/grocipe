import 'package:flutter/material.dart';
import 'package:grocipe/helper/utils/context_extension.dart';

class AppProgressIndicator extends StatelessWidget {
  final int length;
  final int completed;
  const AppProgressIndicator({super.key, this.length = 4, this.completed = 0});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < length; i++)
          Container(
            height: 4,
            width: i < (completed) ? 30 : 20,
            margin: EdgeInsets.only(right: i < (length - 1) ? 8 : 0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: i < (completed)
                  ? context.primaryColor
                  : context.colors.greyDecor,
            ),
          ),
      ],
    );
  }
}

class AppLinearProgressIndicator extends StatelessWidget {
  final int length;
  final int completed;
  const AppLinearProgressIndicator(
      {super.key, this.length = 4, this.completed = 0});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            for (int i = 0; i < length; i++)
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      left: i == 0 ? const Radius.circular(16) : Radius.zero,
                      right: i == length - 1
                          ? const Radius.circular(16)
                          : Radius.zero,
                    ),
                    color: i < completed
                        ? context.primaryColor
                        : context.colors.greyDecor,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "Step $completed/$length",
          style: context.textTheme.titleSmall
              ?.copyWith(color: context.colors.captionGrey),
        )
      ],
    );
  }
}
