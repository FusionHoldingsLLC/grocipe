import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/app/app_widgets/image_render_widget.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/datetime_extension.dart';
import 'package:grocipe/models/order.dart';
import 'package:grocipe/models/states/app_state.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/ui/provider/grocery_provider/order_provider.dart';
import 'package:grocipe/ui/screens/grocery_list/widgets/grocery_shimmer.dart';

class GroceryHistory extends ConsumerStatefulWidget {
  const GroceryHistory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroceryHistoryState();
}

class _GroceryHistoryState extends ConsumerState<GroceryHistory> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(orderProvider.notifier).getGroceryOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final searchController = TextEditingController();
    final orderState = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: AppBackButton(
          onTap: () async {
            ref.read(orderProvider.notifier).getSingleGroceryOrder('');
            context.pop();
          },
        ),
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
            Consumer(builder: (context, watch, child) {
              return Expanded(
                child: orderState is LoadingAppState
                    ? const GroceryShimmer()
                    : orderState is FailureAppState
                        ? Center(child: Text('Error: $orderState'))
                        : orderState is ListAppState<Order>
                            ? ListView.builder(
                                itemCount: orderState.data.length,
                                itemBuilder: (context, index) {
                                  final order = orderState.data[index];
                                  return ListTile(
                                    onTap: () {
                                      context.goNamed(Routes.groceryDetail,
                                          extra: order);
                                    },
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: context.colors.green,
                                      child: ImageRenderWidget.network(
                                          imageUrl: order.orderItems?.first
                                              .grocery?.imageData),
                                    ),
                                    title: Text(
                                      order.orderDate!.dateReadable,
                                      style: context.textTheme.titleMedium,
                                    ),
                                    subtitle: Text(
                                        "${(order.orderItems?.length) ?? 0} items"),
                                    trailing: const Icon(Icons.chevron_right),
                                  );
                                },
                              )
                            : const Center(child: Text('No orders found')),
              );
            }),
          ],
        ),
      ),
    );
  }
}
