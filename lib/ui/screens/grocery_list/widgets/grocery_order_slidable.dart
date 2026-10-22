import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grocipe/app/app_widgets/image_render_widget.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/settings/dev_functions.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/models/order.dart';
import 'package:grocipe/models/states/app_state.dart';
import 'package:grocipe/ui/provider/grocery_provider/order_provider.dart';
import 'package:grocipe/ui/screens/grocery_list/local_widget/add_grocery.dart';
import 'package:grocipe/ui/screens/grocery_list/widgets/grocery_checkbox.dart';

class GrocerySlidable extends ConsumerWidget {
  final OrderItem grocery;
  final bool isCompletedTabSelected;
  final OrderProvider notifier;
  final ValueNotifier btnNotifier;
  final Function checkAndShowDialog;

  const GrocerySlidable({
    Key? key,
    required this.grocery,
    required this.isCompletedTabSelected,
    required this.notifier,
    required this.btnNotifier,
    required this.checkAndShowDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final orderState = ref.watch(orderProvider);

    return Slidable(
      key: ValueKey(grocery.id),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dragDismissible: false,
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          if (isCompletedTabSelected)
            SlidableAction(
              onPressed: (context) {
                notifier.updateOrderItemCompletionStatus(grocery, true);
              },
              backgroundColor: context.primaryColor,
              foregroundColor: Colors.white,
              icon: Icons.check_circle_outline,
              label: "Mark Completed",
            ),
          if (!isCompletedTabSelected)
            SlidableAction(
              onPressed: (context) {
                notifier.updateOrderItemCompletionStatus(grocery, false);
              },
              backgroundColor: context.errorColor,
              foregroundColor: Colors.white,
              icon: Icons.check_circle_outline,
              label: "Mark Uncompleted",
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          onTap: () async {
            await showModalBottomSheet(
              context: context,
              elevation: 50,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return AddGrocery(
                  initGrocery: grocery.grocery,
                  initialQuantity: (grocery.itemQuantity ?? 0).toString(),
                  onSelect: (id) {},
                );
              },
            );

            await notifier.getSingleGroceryOrder("");
          },
          visualDensity: const VisualDensity(vertical: 3),
          leading: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            child: ImageRenderWidget.network(
              imageUrl: grocery.grocery?.imageData ??
                  DevFunction.getAnoymousProfile(),
              height: 85,
              width: 90,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            grocery.grocery?.itemName ?? l10n.unknownItem,
            style: const TextStyle(fontSize: 15),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(grocery.grocery?.brandName ?? l10n.unknownBrand),
              Text(
                grocery.grocery?.category ?? l10n.unknownCategory,
                style: const TextStyle(fontSize: 10),
              )
            ],
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GroceryCheckbox(orderItem: grocery, () {
                if (orderState is SuccessAppState<Order> &&
                    notifier.hasAllOrderComplete(
                        orderState.data.orderItems ?? [])) {
                  checkAndShowDialog();
                }
              }),
              InkWell(
                onTap: () async {
                  // await showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return AddGrocery(
                  //       initGrocery: grocery.grocery,
                  //       initialQuantity: (grocery.itemQuantity ?? 0).toString(),
                  //       onSelect: (id) {},
                  //     );
                  //   },
                  // );
                  await notifier.getGroceryOrder();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Quantity :",
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: context.colors.black,
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        (grocery.itemQuantity ?? 0).toString(),
                        style: context.textTheme.titleMedium
                            ?.copyWith(color: context.colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
