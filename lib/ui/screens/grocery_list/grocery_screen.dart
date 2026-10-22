import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/helper/size_config/size_config.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/models/grocery_list.dart';
import 'package:grocipe/models/order.dart';
import 'package:grocipe/models/states/app_state.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/ui/provider/grocery_provider/grocery_provider.dart';
import 'package:grocipe/ui/provider/grocery_provider/order_provider.dart';
import 'package:grocipe/ui/screens/grocery_list/local_widget/add_grocery.dart';
import 'package:grocipe/ui/screens/grocery_list/widgets/empty_grocery_widget.dart';
import 'package:grocipe/ui/screens/grocery_list/widgets/filter_widget.dart';
import 'package:grocipe/ui/screens/grocery_list/widgets/grocery_order_slidable.dart';
import 'package:grocipe/ui/screens/grocery_list/widgets/grocery_shimmer.dart';
import 'package:grocipe/ui/screens/grocery_list/widgets/mark_as_done.dart';

class GroceryScreen extends ConsumerStatefulWidget {
  const GroceryScreen({super.key});

  @override
  ConsumerState<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends ConsumerState<GroceryScreen>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<Key> screenKeyNotifier =
      ValueNotifier(const Key('initial_key'));
  TextEditingController searchController = TextEditingController();
  TabController? tabController;
  bool isCompletedTabSelected = true;

  late OrderProvider notifier;

  @override
  void initState() {
    super.initState();

    searchController.clear();
    notifier = ref.read(orderProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifier.getSingleGroceryOrder("11");
    });

    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(() {
      setState(() {
        isCompletedTabSelected = tabController?.index == 0;
      });
    });
  }

  @override
  void dispose() {
    tabController?.dispose();
    searchController.dispose();
    super.dispose();
  }

  final btnNotifier = ValueNotifier(false);

  void rebuildWidget() {
    screenKeyNotifier.value =
        Key('key_${DateTime.now().millisecondsSinceEpoch}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DefaultTabController(
      length: 2,
      child: ValueListenableBuilder<Key>(
        valueListenable: screenKeyNotifier,
        builder: (context, key, child) {
          return Scaffold(
            key: key,
            appBar: AppBar(
              title: Text(l10n.groceryList),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () async {
                    await context.pushNamed(Routes.groceryHistory);
                    notifier.getSingleGroceryOrder("11");
                  },
                  child: Row(
                    children: [
                      Text(
                        l10n.history,
                        style: context.textTheme.titleMedium
                            ?.copyWith(color: context.primaryColor),
                      ),
                      const Gap(5),
                      Icon(
                        Icons.history,
                        color: context.primaryColor,
                      )
                    ],
                  ),
                ),
                const Gap(20),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Padding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Consumer(
                                          builder: (context, ref, child) {
                                            final groceryState =
                                                ref.watch(groceryProvider);

                                            return AppInputField(
                                              child: TextField(
                                                controller: searchController,
                                                onChanged: (value) {
                                                  if (value.length > 3) {
                                                    ref
                                                        .read(groceryProvider
                                                            .notifier)
                                                        .searchGrocery(
                                                            value, '')
                                                        .then((results) {
                                                      setState(() {
                                                        // handle results
                                                      });
                                                    });
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  hintText: context
                                                      .l10n.searchPlaceholder,
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: Palette.grey,
                                                  ),
                                                  suffixIcon: groceryState
                                                          is LoadingAppState
                                                      ? CupertinoActivityIndicator(
                                                          color: Colors.grey)
                                                      : null,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Other widgets below the search bar
                              ],
                            ),
                            const Gap(10),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  color: context.colors.greyOutline,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TabBar(
                                controller: tabController,
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelStyle: TextStyle(
                                  color: Palette.white,
                                ),
                                unselectedLabelColor: Palette.black,
                                indicatorColor:
                                    Theme.of(context).colorScheme.secondary,
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Palette.black,
                                ),
                                tabs: [
                                  Tab(
                                    icon: Text(l10n.shopping),
                                  ),
                                  Tab(
                                    icon: Text(l10n.completed),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(5),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return const SortBottomSheet();
                                });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Sort',
                                style: context.textTheme.titleMedium,
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                              )
                            ],
                          ),
                        ),
                        const Gap(5),
                        Expanded(
                          child: Consumer(
                            builder: (context, ref, child) {
                              final orderState = ref.watch(orderProvider);
                              if (orderState is LoadingAppState) {
                                return const GroceryShimmer();
                              } else if (orderState is SuccessAppState<Order>) {
                                var data = [];

                                if (orderState.data.orderCompleted ?? false) {
                                  data = notifier.filterOrders(
                                      [], !isCompletedTabSelected);

                                  return const EmptyGroceryWidget();
                                } else {
                                  data = notifier.filterOrders(
                                      orderState.data.orderItems ?? [],
                                      !isCompletedTabSelected);

                                  print(
                                      "This is the data of uncompleted $data");

                                  if (notifier.sortingCriteria == 'By Aisle') {
                                    Map<String, List<OrderItem>>
                                        groupedByRecipe = {};
                                    for (var item in data) {
                                      final category = item.grocery?.category ??
                                          'Unknown Category';
                                      if (!groupedByRecipe
                                          .containsKey(category)) {
                                        groupedByRecipe[category] = [];
                                      }
                                      groupedByRecipe[category]!.add(item);
                                    }

                                    return Column(
                                      children: [
                                        if (notifier.hasAllOrderComplete(
                                                orderState.data.orderItems ??
                                                    []) &&
                                            isCompletedTabSelected)
                                          MarkDoneButton(
                                            btnNotifier: btnNotifier,
                                            refresh: () async {
                                              await notifier
                                                  .getSingleGroceryOrder("11");
                                              rebuildWidget();
                                            },
                                          ),
                                        Expanded(
                                          child: ListView(
                                            children: groupedByRecipe.keys
                                                .map((recipe) {
                                              return Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                    color: context
                                                        .colors.greyOutline,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: ExpansionTile(
                                                  title: Text(recipe),
                                                  children:
                                                      groupedByRecipe[recipe]!
                                                          .map((grocery) =>
                                                              Container(
                                                                color: context
                                                                    .colors
                                                                    .white,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            3),
                                                                child:
                                                                    GrocerySlidable(
                                                                  grocery:
                                                                      grocery,
                                                                  isCompletedTabSelected:
                                                                      isCompletedTabSelected,
                                                                  notifier:
                                                                      notifier,
                                                                  btnNotifier:
                                                                      btnNotifier,
                                                                  checkAndShowDialog:
                                                                      checkAndShowDialog,
                                                                ),
                                                              ))
                                                          .toList(),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        if (notifier.hasAllOrderComplete(
                                                orderState.data.orderItems ??
                                                    []) &&
                                            isCompletedTabSelected)
                                          MarkDoneButton(
                                            btnNotifier: btnNotifier,
                                            refresh: () async {
                                              await notifier
                                                  .getSingleGroceryOrder("11");
                                              rebuildWidget();
                                            },
                                          ),
                                        Expanded(
                                          child: ListView.separated(
                                            separatorBuilder:
                                                (context, index) =>
                                                    const Gap(10),
                                            itemCount: (data.length),
                                            itemBuilder: (context, index) {
                                              var grocery = data[index];
                                              print(
                                                  "This is the grocerylist (${data.length})");

                                              return GrocerySlidable(
                                                grocery: grocery,
                                                isCompletedTabSelected:
                                                    isCompletedTabSelected,
                                                notifier: notifier,
                                                btnNotifier: btnNotifier,
                                                checkAndShowDialog:
                                                    checkAndShowDialog,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }
                              } else {
                                return Center(
                                    child: Text(l10n.searchGroceries));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    if (searchController.text.isNotEmpty)
                      Positioned(
                        top: 70,
                        left: 0,
                        right: 0,
                        child: Consumer(
                          builder: (context, ref, child) {
                            final groceryState = ref.watch(groceryProvider);

                            if (groceryState is ListAppState<Grocery>) {
                              return Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 400,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20))),
                                  child: ListView.builder(
                                    itemCount: groceryState.data.length,
                                    itemBuilder: (context, index) {
                                      bool isInOrder = ref
                                              .read(orderProvider.notifier)
                                              .orderItems
                                              ?.any((orderItem) =>
                                                  orderItem.itemId ==
                                                  groceryState
                                                      .data[index].id) ??
                                          false;
                                      return ListTile(
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                groceryState
                                                        .data[index].itemName ??
                                                    'No name',
                                              ),
                                            ),
                                            isInOrder
                                                ? const Icon(Icons.check,
                                                    color: Colors.green)
                                                : InkWell(
                                                    onTap: () async {
                                                      await showModalBottomSheet(
                                                          context: context,
                                                          elevation: 50,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          isScrollControlled:
                                                              true,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AddGrocery(
                                                              initGrocery:
                                                                  groceryState
                                                                          .data[
                                                                      index],
                                                              onSelect: (id) {},
                                                            );
                                                          });

                                                      await notifier
                                                          .getSingleGroceryOrder(
                                                              "11");

                                                      rebuildWidget();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "Add",
                                                        style: context.textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                                color: context
                                                                    .primaryColor),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                        onTap: () {
                                          searchController.text = groceryState
                                                  .data[index].itemName ??
                                              '';
                                          Navigator.pop(
                                              context); // Close dropdown on selection
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // floatingActionButton: CircleAvatar(
            //   radius: 30,
            //   backgroundColor: context.primaryColor,
            //   child: FloatingActionButton(
            //     backgroundColor: context.colors.white,
            //     shape: const CircleBorder(),
            //     child: Icon(
            //       Icons.add,
            //       color: context.primaryColor,
            //     ),
            //     onPressed: () async {
            //       await showModalBottomSheet(
            //           context: context,
            //           elevation: 50,
            //           backgroundColor: Colors.transparent,
            //           isScrollControlled: true,
            //           builder: (BuildContext context) {
            //             return AddGrocery(
            //               onSelect: (id) {},
            //             );
            //           });

            //       await notifier.getSingleGroceryOrder("11");
            //       rebuildWidget();
            //     },
            //   ),
            // ),
          );
        },
      ),
    );
  }

  void checkAndShowDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text(
              "There are both completed and incomplete orders. Do you want to continue?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Continue"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
