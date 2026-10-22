// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/app/app_widgets/custom_text_button.dart';
import 'package:grocipe/helper/size_config/size_config.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/models/grocery_list.dart';
import 'package:grocipe/models/order.dart';
import 'package:grocipe/models/states/app_state.dart';
import 'package:grocipe/services/grocery_service.dart';
import 'package:grocipe/ui/provider/grocery_provider/grocery_provider.dart';
import 'package:grocipe/ui/provider/grocery_provider/order_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddGrocery extends ConsumerStatefulWidget {
  const AddGrocery({
    super.key,
    required this.onSelect,
    this.initGrocery,
    this.initialQuantity,
  });
  final Function(String id) onSelect;
  final Grocery? initGrocery;
  final String? initialQuantity;

  @override
  ConsumerState<AddGrocery> createState() => _AddGroceryState();
}

class _AddGroceryState extends ConsumerState<AddGrocery> with Validators {
  TextEditingController searchController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  final groceryForm = GlobalKey<FormState>();
  final btnNotifier = ValueNotifier(false);

  late OrderProvider orderNotifier;

  bool allowCreate = false;

  @override
  void initState() {
    super.initState();
    orderNotifier = ref.read(orderProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      selectedGrocery = widget.initGrocery;
      quantityController.text = widget.initialQuantity ?? "1";
      searchController.text = widget.initGrocery?.itemName ?? "";
      ref.read(groceryProvider.notifier).searchGrocery('', '');

      btnNotifier.value = true;
      final result = await orderNotifier.getSingleGroceryOrderBool("");
      btnNotifier.value = false;
      if ((result)) {
        setState(() => allowCreate = true);
      } else {
        // context.showErrorSnackBar("Failed to fetch!");
      }
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    ref.read(groceryProvider.notifier).searchGrocery(searchController.text, '');
  }

  Grocery? selectedGrocery;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      // height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.colors.white,
      ),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: groceryForm,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Gap(10),
                    AppInputField(
                      title: "Add Grocery",
                      child: Consumer(
                        builder: (context, watch, child) {
                          final groceryState = ref.watch(groceryProvider);
                          return Column(
                            children: [
                              TextFormField(
                                validator: validateName,
                                controller: searchController,
                                onChanged: (value) {
                                  if (value.length > 3) {
                                    selectedGrocery = null;
                                    ref
                                        .read(groceryProvider.notifier)
                                        .searchGrocery(value, '');
                                  }
                                },
                                decoration: const InputDecoration(
                                  hintText: "i.e carrot",
                                ),
                              ),
                              if (groceryState is ListAppState<Grocery>)
                                if (groceryState.data.isNotEmpty)
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: context.colors.greyOutline,
                                            width: 1.5),
                                        borderRadius: BorderRadius.circular(8)),
                                    constraints:
                                        const BoxConstraints(maxHeight: 100),
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          const Gap(1),
                                      itemCount: groceryState.data.length,
                                      itemBuilder: (context, index) {
                                        final grocery =
                                            groceryState.data[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              searchController.text =
                                                  grocery.itemName ?? "";

                                              selectedGrocery = grocery;

                                              ref
                                                  .read(
                                                      groceryProvider.notifier)
                                                  .searchGrocery('', '');
                                            },
                                            child: Text(
                                              grocery.itemName ?? "",
                                              style:
                                                  context.textTheme.titleMedium,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                            ],
                          );
                        },
                      ),
                    ),
                    const Gap(20),
                    QuantityDropdown(
                      controller: quantityController,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomTextButton(
                          text: "cancel",
                          fontsize: 16,
                          onPressed: () {
                            context.pop();
                          },
                        ),
                      ),
                      Expanded(
                        child: AppElevatedButton(
                          notifier: btnNotifier,
                          onPressed: allowCreate
                              ? createGroceryOrder
                              : updateGroceryOrder,
                          style: context.elevatedButtonTheme.style?.copyWith(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                context.primaryColor),
                          ),
                          child: const Text("Add"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future updateGroceryOrder() async {
    if (!groceryForm.currentState!.validate()) return;

    _groceryorderBox = await Hive.openBox('groceryOrdersCache');
    if (selectedGrocery == null) {
      context.showMessage("Select a grocery item");
      return;
    }
    try {
      btnNotifier.value = true;

      OrderItem orderItem = OrderItem(
          itemId: selectedGrocery?.id,
          itemQuantity: int.tryParse(quantityController.text),
          itemPrice: selectedGrocery?.price,
          itemCompleted: false,
          grocery: selectedGrocery);

      var orderItems = orderNotifier.order.orderItems;
      orderItems ??= [];

      bool itemExists =
          orderItems.any((item) => item.itemId == orderItem.itemId);

      if (!itemExists) {
        orderItems.add(orderItem);
      }

      var order = orderNotifier.order;

      order = orderNotifier.order.copyWith(orderItems: orderItems);

      btnNotifier.value = true;
      final res =
          await ref.read(groceryService).updateGroceryOrder(order.toApiMap());

      await _groceryorderBox?.put('groceryOrdersCache', res);

      btnNotifier.value = false;
      context.pop();
    } catch (error) {
      context.showErrorSnackBar(error);
    } finally {
      btnNotifier.value = false;
    }
  }

  GroceryService get service => ref.read(groceryService);
  Box<Order>? _groceryorderBox;
  Future createGroceryOrder() async {
    if (!groceryForm.currentState!.validate()) return;

    _groceryorderBox = await Hive.openBox('groceryOrdersCache');
    if (selectedGrocery == null) {
      context.showMessage("Select a grocery item");
      return;
    }
    try {
      btnNotifier.value = true;
      await ref.read(groceryService).createGroceryOrder({
        "order_date": DateTime.now().toIso8601String(),
        "order_completed": false,
        "order_total": selectedGrocery?.price,
        "order_items": [
          {
            "item_id": selectedGrocery?.id,
            "item_quantity": quantityController.text,
            "item_price": selectedGrocery?.price,
            "item_completed": false
          }
        ]
      });

      final res = await service.getSingleGroceryOrder('');
      await _groceryorderBox?.put('groceryOrdersCache', res);

      btnNotifier.value = false;
      context.pop();
    } catch (error) {
      context.showErrorSnackBar(error);
    } finally {
      btnNotifier.value = false;
    }
  }
}

class QuantityDropdown extends StatefulWidget {
  final TextEditingController controller;

  const QuantityDropdown({super.key, required this.controller});

  @override
  _QuantityDropdownState createState() => _QuantityDropdownState();
}

class _QuantityDropdownState extends State<QuantityDropdown> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    quantity = int.tryParse(widget.controller.text) ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return AppBorderInputField(
      title: "Quantity",
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<int>(
              value: quantity,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: List.generate(10, (index) => index + 1)
                  .map((value) => DropdownMenuItem<int>(
                        value: value,
                        child: SizedBox(
                            width: SizeConfig.widthOf(75),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(value.toString()),
                            )),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  quantity = value ?? 1;
                  widget.controller.text = quantity.toString();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
