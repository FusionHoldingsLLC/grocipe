import 'package:flutter/material.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/helper/constants/svg_path.dart';
import 'package:grocipe/helper/utils/context_extension.dart';

class EmptyGroceryWidget extends StatelessWidget {
  const EmptyGroceryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 25),
          const Center(
            child: SvgRenderWidget(
              svgPath: SvgPath.itemEmpty2,
              height: 250.0,
              width: 300.0,
            ),
          ),
          const SizedBox(height: 15),
          Text('No item added yet', style: context.textTheme.displayMedium),
          Text(
              'Click on the history at the top of the \nscreen to see older items',
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium)
        ],
      ),
    );
  }
}
