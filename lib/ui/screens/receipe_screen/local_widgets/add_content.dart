import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grocipe/helper/utils/context_extension.dart';

class AddContent extends StatelessWidget {
  const AddContent({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            Icons.add_circle_outline_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
          Gap(10),
          Text(
            text,
            style: context.textTheme.titleMedium
                ?.copyWith(color: context.primaryColor),
          )
        ],
      ),
    );
  }
}
