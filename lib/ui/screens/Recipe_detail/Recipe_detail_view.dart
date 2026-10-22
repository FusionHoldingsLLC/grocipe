import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/image_render_widget.dart';
import 'package:grocipe/models/health.dart';
import 'package:grocipe/models/ingredient.dart';
import 'package:grocipe/models/instruction.dart';
import 'package:grocipe/models/nutrition.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/models/order.dart';
import 'package:grocipe/models/recipe.dart';
import 'package:grocipe/helper/settings/dev_functions.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/services/grocery_service.dart';
import 'package:grocipe/ui/provider/grocery_provider/order_provider.dart';
import 'package:grocipe/ui/screens/home_screen/local_widget/more_options.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:url_launcher/url_launcher.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipe});
  final Object recipe;
  // final String? id;
  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  late Recipe recipe;
  late OrderProvider orderNotifier;

  GroceryService get service => ref.read(groceryService);
  @override
  void initState() {
    super.initState();
    orderNotifier = ref.read(orderProvider.notifier);
    if (widget.recipe is Recipe) {
      recipe = widget.recipe as Recipe;
      print(recipe.url ?? "");
    } else {
      print('The object is not a Recipe.');
    }
  }

  // PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 1;

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showAllergyWarnings(
      BuildContext context, List<HealthReport> healthReports) {
    showFlexibleBottomSheet(
      bottomSheetColor: Colors.transparent,
      initHeight: 0.45,
      context: context,
      builder: (context, scrollController, bottomSheetOffset) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xffF1FFFD),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Container(
            color: const Color(0xffF1FFFD),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Allergy Warnings',
                    style: context.textTheme.displayMedium,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...healthReports.map((report) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              report.note,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                // const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ),
                const Gap(10)
              ],
            ),
          ),
        );
      },
      anchors: [0, 0.5, 1],
      isSafeArea: true,
    );
  }

  final btnNotifier = ValueNotifier(false);
  bool isLoading = false;
  toogleBTNNotifier(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Box<Order>? _groceryorderBox;
  Future<void> createGroceryOrder(List<Ingredient> ingredients) async {
    try {
      toogleBTNNotifier(true);
      _groceryorderBox = await Hive.openBox('groceryOrdersCache');
      List<OrderItem>? newOrderItems = [];
      var orderItems = orderNotifier.order.orderItems;
      orderItems ??= [];
      var order = orderNotifier.order;

      for (var ingredient in ingredients) {
        if (ingredient.groceryId != null && ingredient.groceryId != 0) {
          var existingOrderItem = orderItems.firstWhereOrNull(
            (item) => item.itemId == ingredient.groceryId,
          );

          if (existingOrderItem?.grocery != null) {
            existingOrderItem?.itemQuantity =
                (existingOrderItem.itemQuantity ?? 0) + 1;
          } else {
            newOrderItems.add(
              OrderItem(
                itemId: ingredient.groceryId,
                itemQuantity: 1,
                itemPrice: "0.00",
                itemCompleted: false,
              ),
            );
          }
        }
      }
      orderItems.addAll(newOrderItems);
      order = orderNotifier.order.copyWith(orderItems: orderItems);
      await ref.read(groceryService).updateGroceryOrder(order.toApiMap());
      final res = await service.getSingleGroceryOrder('');
      await _groceryorderBox?.put('groceryOrdersCache', res);
      context.showSuccessSnackBar(
          'Grocery created successfully with ${newOrderItems.length} items.');
    } catch (e) {
      context.showErrorSnackBar('Failed to create grocery order: $e');
    } finally {
      toogleBTNNotifier(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: 100,
        title: Text(l10n.detail_screen_title),
        actions: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.captionGrey.withOpacity(.15),
            ),
            child: IconButton(
              onPressed: () {
                showFlexibleBottomSheet(
                  bottomSheetColor: Colors.transparent,
                  initHeight: 0.3,
                  context: context,
                  builder: (context, scrollController, bottomSheetOffset) {
                    return MoreOptions(recipe: recipe);
                  },
                  anchors: [0, 0.5, 1],
                  isSafeArea: true,
                );
              },
              highlightColor: context.primaryColor,
              icon: Icon(
                Icons.more_horiz,
                color: context.colors.black,
              ),
            ),
          ),
          const SizedBox(width: 20)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: recipe.id,
              child: Container(
                height: 211,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ImageRenderWidget.network(
                    imageUrl: recipe.recipeImages.isEmpty
                        ? DevFunction.getAnoymousProfile()
                        : recipe.recipeImages[0].imageData,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Gap(20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Gap(2),
                      GestureDetector(
                        onTap: () {
                          if (recipe.url != null) {
                            _launchURL(recipe.url!);
                          }
                        },
                        child: Text(
                          recipe.author ?? recipe.url ?? "",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                // IconButton(
                //     onPressed: () {
                //       showAllergyWarnings(context, recipe.healthReports);
                //     },
                //     icon: const Icon(Icons.info_outline))
              ],
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: context.colors.greyDecor),
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          CupertinoIcons.clock,
                          color: context.primaryColor,
                        ),
                        Text(
                          " ${recipe.totalTime}${l10n.minutes_label}",
                          maxLines: 1,
                          style: context.textTheme.titleSmall
                              ?.copyWith(color: context.colors.captionGrey),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(20),
                Expanded(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: context.colors.greyDecor),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          CupertinoIcons.speedometer,
                          color: context.primaryColor,
                        ),
                        Text(
                          "${recipe.servings}${l10n.servings_label}",
                          maxLines: 1,
                          style: context.textTheme.titleSmall
                              ?.copyWith(color: context.colors.captionGrey),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(20),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      createGroceryOrder(recipe.ingredients!);
                    },
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: context.primaryColor),
                      padding: const EdgeInsets.all(20),
                      child: isLoading
                          ? const CupertinoActivityIndicator(
                              color: Colors.white)
                          : Column(
                              children: [
                                Icon(
                                  CupertinoIcons.cart,
                                  color: context.colors.white,
                                ),
                                Text(
                                  "Grocipe",
                                  maxLines: 1,
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(color: context.colors.white),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(20),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Palette.darkWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TabBarButton(
                      text: l10n.ingredient_tab,
                      onTap: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                      iscurrent: _currentIndex == 0,
                    ),
                  ),
                  Expanded(
                    child: TabBarButton(
                      text: l10n.instructions_tab,
                      onTap: () {
                        setState(() {
                          _currentIndex = 1;
                        });
                      },
                      iscurrent: _currentIndex == 1,
                    ),
                  ),
                  Expanded(
                    child: TabBarButton(
                      text: l10n.nutritions_tab,
                      onTap: () {
                        setState(() {
                          _currentIndex = 2;
                        });
                      },
                      iscurrent: _currentIndex == 2,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            if (_currentIndex == 0) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: (recipe.ingredients?.length ?? 0),
                  itemBuilder: (context, index) {
                    if (recipe.ingredients == null) {
                      return const SizedBox.shrink();
                    }
                    Ingredient ingredient = recipe.ingredients![index];
                    return Container(
                      child: ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Palette.grey.withOpacity(.3),
                              child: Center(
                                child: Text(
                                  (index + 1).toString(),
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(color: context.colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          ingredient.name,
                        ),
                      ),
                    );
                  },
                ),
              )
            ] else if (_currentIndex == 1) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: recipe.instructions.length,
                  itemBuilder: (context, index) {
                    Instruction2 instruction = recipe.instructions[index];
                    return Container(
                      child: ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Palette.grey.withOpacity(.3),
                              child: Center(
                                child: Text(
                                  (index + 1).toString(),
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(color: context.colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          instruction.instruction,
                        ),
                      ),
                    );
                  },
                ),
              )
            ] else if (_currentIndex == 2) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: recipe.nutritionalFacts.length,
                  itemBuilder: (context, index) {
                    NutritionalFact nutritionalFact =
                        recipe.nutritionalFacts[index];
                    return Container(
                      child: ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Palette.grey.withOpacity(.3),
                              child: Center(
                                child: Text(
                                  (index + 1).toString(),
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(color: context.colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          nutritionalFact.name,
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            nutritionalFact.value,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ]
          ],
        ),
      ),
      floatingActionButton: recipe.instructions.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                context.go(
                  '/main_screen/recipe/view/demo',
                  extra: recipe,
                );
              },
              child: Icon(
                Icons.play_arrow_rounded,
                size: 40,
                color: context.colors.white,
              ),
            )
          : null,
    );
  }
}

class TabBarButton extends StatelessWidget {
  const TabBarButton({
    super.key,
    // required this.backgroudColor,
    // required this.color,
    required this.iscurrent,
    required this.onTap,
    required this.text,
  });
  final String text;
  final bool iscurrent;
  // final Color backgroudColor;
  // final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: iscurrent ? context.colors.black : Palette.darkWhite),
        height: 48,
        child: Center(
          child: Text(text,
              style: context.textTheme.titleMedium?.copyWith(
                color: iscurrent ? Palette.darkWhite : context.colors.black,
              )),
        ),
      ),
    );
  }
}
