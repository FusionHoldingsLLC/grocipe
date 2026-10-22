import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/app/app_widgets/image_render_widget.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/models/order.dart';

class GroceryDetail extends StatefulWidget {
  final Order order;

  const GroceryDetail({super.key, required this.order});

  @override
  State<GroceryDetail> createState() => _GroceryDetailState();
}

class _GroceryDetailState extends State<GroceryDetail> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: const AppBackButton(),
        title: Text(l10n.history),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            AppInputField(
              child: TextField(
                controller: searchController,
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: l10n.searchPlaceholder,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Palette.grey,
                  ),
                ),
              ),
            ),
            const Gap(20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.order.orderItems?.length ?? 0,
                itemBuilder: (context, index) {
                  final orderItem = widget.order.orderItems?[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      visualDensity: const VisualDensity(vertical: 3),
                      leading: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        child: ImageRenderWidget.network(
                          imageUrl: orderItem?.grocery?.imageData,
                          height: 85,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        orderItem?.grocery?.itemName ?? "Unknown Item",
                        style: const TextStyle(fontSize: 15),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(orderItem?.grocery?.subCategory ??
                              "Unknown Brand"),
                          Text(
                            orderItem?.grocery?.category ?? "Unknown Category",
                            style: const TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                      trailing: const Column(
                        children: [
                          // Text(orderItem.date ?? "Unknown Date"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
