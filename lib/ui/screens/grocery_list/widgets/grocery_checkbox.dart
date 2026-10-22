import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/models/order.dart';
import 'package:grocipe/ui/provider/grocery_provider/order_provider.dart';

class GroceryCheckbox extends ConsumerStatefulWidget {
  final OrderItem orderItem;
  final VoidCallback checkForCompleted;

  const GroceryCheckbox(
    this.checkForCompleted, {
    Key? key,
    required this.orderItem,
  }) : super(key: key);

  @override
  ConsumerState createState() => _GroceryCheckboxState();
}

class _GroceryCheckboxState extends ConsumerState<GroceryCheckbox> {
  // bool isChecked = . ;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      activeColor: Theme.of(context).colorScheme.secondary,
      side: BorderSide(
        color: Palette.grey,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      value: widget.orderItem.itemCompleted,
      onChanged: (value) async {
        setState(() {
          widget.orderItem.itemCompleted = value ?? false;
        });
        await ref
            .read(orderProvider.notifier)
            .updateOrderItemCompletionStatus(widget.orderItem, value!);
      },
    );
  }
}
