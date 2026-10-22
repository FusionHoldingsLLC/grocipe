// mark_done_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/helper/constants/svg_path.dart';
import 'package:grocipe/ui/provider/grocery_provider/order_provider.dart';

class MarkDoneButton extends ConsumerWidget {
  final ValueNotifier<bool> btnNotifier;
  final VoidCallback refresh;

  const MarkDoneButton(
      {Key? key, required this.btnNotifier, required this.refresh})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Center(
            child: SvgRenderWidget(
              svgPath: SvgPath.doneShopping,
              height: 200.0,
              width: 300.0,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AppElevatedButton(
            notifier: btnNotifier,
            onPressed: () async {
              btnNotifier.value = true;
              await ref.read(orderProvider.notifier).markOrderAsDone();
              btnNotifier.value = false;
              refresh();
            },
            child: const Text("Mark as Done"),
          ),
        ],
      ),
    );
  }
}
