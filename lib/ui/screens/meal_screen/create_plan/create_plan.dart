// ignore_for_file: unused_local_variable, unnecessary_null_comparison, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/app/app_widgets/image_render_widget.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/helper/constants/const.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/settings/dev_functions.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/helper/size_config/size_config.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/models/grocery_list.dart';
import 'package:grocipe/models/plan.dart';
import 'package:grocipe/models/recipe.dart';
import 'package:grocipe/models/states/app_state.dart';
import 'package:grocipe/models/weekly_mealplan.dart';
import 'package:grocipe/ui/provider/grocery_provider/grocery_provider.dart';
import 'package:grocipe/ui/provider/grocery_provider/recipe_provider.dart';

import 'package:grocipe/ui/screens/meal_screen/create_plan/data/create_plan_data.dart';
import 'package:grocipe/ui/screens/meal_screen/meal_plan_providers/meal_plan_menu_provider.dart';
import 'package:grocipe/ui/screens/meal_screen/meal_plan_providers/mealplan_provider.dart';

class CreatePlan extends ConsumerStatefulWidget {
  const CreatePlan({
    super.key,
    required this.plan,
  });
  final PlanExtras plan;

  static String id = "create_plan";
  @override
  ConsumerState<CreatePlan> createState() => _CreatePlanState();
}

class _CreatePlanState extends ConsumerState<CreatePlan> {
  TextEditingController searchController = TextEditingController();
  TextEditingController searchController2 = TextEditingController();
  List<Recipe> recipes = [];
  List<Recipe> filteredRecipes = [];
  List<Recipe> selectedRecipe = [];
  List<Grocery> groceries = [];
  final btnNotifier = ValueNotifier(false);

  RecipeProvider? notifier;

  int? createID;
  @override
  void initState() {
    notifier = ref.read(recipeProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!widget.plan.plan.dateIsRegistered &&
          widget.plan.mealPlanMenu.id == null) {
        ref.read(mealplanProvider.notifier).createMealplan(
            convertToDateString(widget.plan.plan.startDate),
            convertToDateString(widget.plan.plan.endDate));
      }

      recipes = await notifier?.getRecipes();
      filteredRecipes = recipes;
    });

    super.initState();
  }

  void filterRecipes(String query) {
    setState(() {
      filteredRecipes = recipes
          .where((recipe) =>
              recipe.name != null &&
              recipe.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: const AppBackButton(),
            title: const Text('Meal Plan'),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Builder(builder: (context) {
                        final currentIndex =
                            DefaultTabController.of(context).index;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: AppInputField(
                            child: TextField(
                              controller: currentIndex == 0
                                  ? searchController2
                                  : searchController,
                              onChanged: (value) {
                                setState(() {});
                                if (currentIndex == 0) {
                                  filterRecipes(value);
                                } else {
                                  if (value.length > 3) {
                                    ref
                                        .read(groceryProvider.notifier)
                                        .searchGrocery(value, '');
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: l10n.searchPlaceholder,
                                prefixIcon: const SizedBox(
                                  width: 50,
                                  child: Row(children: [
                                    SizedBox(width: 10),
                                    SvgRenderWidget(
                                        svgPath: 'assets/svgs/search.svg')
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      const Gap(20),
                      SizedBox(
                        height: 50,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: context.colors.greyOutline,
                          ),
                          child: TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelStyle: TextStyle(
                              color: Palette.white,
                            ),
                            unselectedLabelColor: Palette.black,
                            indicatorColor:
                                Theme.of(context).colorScheme.secondary,
                            indicator: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(16), // Creates border
                              color: Palette.black,
                            ),
                            tabs: const [
                              Tab(
                                icon: Text(
                                  "Recipes",
                                ),
                              ),
                              Tab(
                                icon: Text("Groceries"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Column(
                              children: [
                                const Gap(10),
                                Expanded(
                                  child: Consumer(
                                      builder: (context, watch, child) {
                                    final recipeState =
                                        ref.watch(recipeProvider);
                                    if (recipeState is LoadingAppState) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (recipeState
                                        is ListAppState<Recipe>) {
                                      return GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 8.0,
                                          crossAxisSpacing: 8.0,
                                          mainAxisExtent: 250,
                                        ),
                                        itemCount: filteredRecipes.length,
                                        itemBuilder: (context, index) {
                                          Recipe recipe =
                                              filteredRecipes[index];

                                          return Column(
                                            children: [
                                              Expanded(
                                                child: Stack(
                                                  children: [
                                                    Positioned.fill(
                                                      child: Hero(
                                                        tag: recipe.id,
                                                        child: SizedBox(
                                                          height: 200,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                            child:
                                                                ImageRenderWidget
                                                                    .network(
                                                              imageUrl: recipe
                                                                      .recipeImages
                                                                      .isEmpty
                                                                  ? DevFunction
                                                                      .getAnoymousProfile()
                                                                  : recipe
                                                                      .recipeImages[
                                                                          0]
                                                                      .imageData,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        onPressed: () {
                                                          if (selectedRecipe
                                                              .contains(
                                                                  recipe)) {
                                                            selectedRecipe
                                                                .remove(recipe);
                                                          } else {
                                                            selectedRecipe
                                                                .add(recipe);
                                                          }
                                                          setState(() {});
                                                        },
                                                        icon: Icon(
                                                            selectedRecipe
                                                                    .contains(
                                                                        recipe)
                                                                ? Icons
                                                                    .check_circle
                                                                : Icons
                                                                    .check_circle_outline_outlined,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Gap(10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                    recipe.name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                          'assets/images/icons/table_clock.png'),
                                                      Text(
                                                          ' ${recipe.totalTime} ${l10n.minutes}')
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    } else if (recipeState is FailureAppState) {
                                      return const Center(
                                          child:
                                              Text("Failed to load recipes"));
                                    } else {
                                      return const Center(
                                          child: Text('Search recipes'));
                                    }
                                  }),
                                ),
                              ],
                            ),
                            // Groceries Tab
                            Column(
                              children: [
                                Expanded(
                                  child: Consumer(
                                    builder: (context, watch, child) {
                                      final groceryState =
                                          ref.watch(groceryProvider);
                                      if (groceryState is LoadingAppState) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (groceryState
                                          is ListAppState<Grocery>) {
                                        return ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              const Gap(10),
                                          itemCount: groceryState.data.length,
                                          itemBuilder: (context, index) {
                                            final grocery =
                                                groceryState.data[index];
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                dense: true,
                                                visualDensity:
                                                    const VisualDensity(
                                                        vertical: 3),
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10)),
                                                  child:
                                                      ImageRenderWidget.network(
                                                    imageUrl: grocery
                                                            .imageData ??
                                                        DevFunction
                                                            .getAnoymousProfile(),
                                                    height: 85,
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                title: Text(
                                                  grocery.itemName ??
                                                      "Unknown Item",
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(grocery.brandName ??
                                                        "Unknown Brand"),
                                                    Text(
                                                      grocery.category ??
                                                          "Unknown Category",
                                                      style: const TextStyle(
                                                          fontSize: 10),
                                                    )
                                                  ],
                                                ),
                                                trailing: SizedBox(
                                                  height: 100,
                                                  width: 50,
                                                  child: Center(
                                                    child: Checkbox(
                                                      checkColor: Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      activeColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                      side: BorderSide(
                                                        color: Palette.grey,
                                                      ),
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      value: groceries
                                                          .contains(grocery),
                                                      onChanged: (value) {
                                                        if (groceries.contains(
                                                            grocery)) {
                                                          groceries
                                                              .remove(grocery);
                                                        } else {
                                                          groceries
                                                              .add(grocery);
                                                        }
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else if (groceryState
                                          is FailureAppState) {
                                        return const Center(child: Text(""));
                                      } else {
                                        return const Center(
                                            child: Text('Search groceries'));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (groceries.isNotEmpty || selectedRecipe.isNotEmpty)
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: SizeConfig.screenWidth * .8,
                        child: AppElevatedButton(
                          notifier: btnNotifier,
                          onPressed: () {
                            updateMealPlan(
                                selectedGrocery: groceries,
                                selectedRecipes: selectedRecipe);
                          },
                          child: const Text("Plan"),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ));
  }

  // Future createMeal(
  //     {required String startDate, required String endDate}) async {
  //   btnNotifier.value = true;

  //   try {
  //     String formattedStartDate = startDate.split(' ')[0];
  //     String formattedEndDate = endDate.split(' ')[0];
  //     var model = ref.read(mealplanProvider.notifier);
  //     await model.createMealplan(formattedStartDate, formattedEndDate);
  //     btnNotifier.value = false;
  //   } catch (e) {
  //     context.showErrorSnackBar(e);
  //   } finally {
  //     btnNotifier.value = false;
  //   }
  // }

  Future updateMealPlan({
    List<Recipe>? selectedRecipes,
    List<Grocery>? selectedGrocery,
  }) async {
    try {
      btnNotifier.value = true;

      var modelReq = ref.read(mealplanProvider.notifier);
      var model = ref.read(mealplanMenuProvider.notifier);

      // var mealPlan = await modelReq
      //     .getStoredMealPlan(convertToDateString(widget.plan.plan.startDate));

      var mealPlan = widget.plan.mealPlanMenu;

      ReqMeal newMeal = ReqMeal(
        recipeId: selectedRecipe.map((e) => e.id).toList(),
        groceryId: selectedGrocery?.map((e) => e.id!).toList(),
        eatingOut: true,
      );

      if (mealPlan != null && mealPlan.id != null) {
        Map<String, dynamic> data = {
          'id': widget.plan.mealPlanMenu.id,
          'week_start_date': convertToDateString(widget.plan.plan.startDate),
          'week_end_date': convertToDateString(widget.plan.plan.endDate),
          'days': [
            {
              widget.plan.plan.day.toLowerCase(): {
                widget.plan.plan.meal.toLowerCase(): [
                  {
                    'recipe_id':
                        selectedRecipe.map((recipe) => recipe.id).toList(),
                    'grocery_id':
                        groceries.map((grocery) => grocery.id).toList(),
                    'eating_out': true,
                  }
                ],
              }
            }
          ]
        };

        var bData = constructBackendData(widget.plan.mealPlanMenu);

        print(bData);

        var uData = updateMealPlanData(
            plan: bData,
            day: widget.plan.plan.day.toLowerCase(),
            meal: widget.plan.plan.meal.toLowerCase(),
            recipeIds: selectedRecipe.map((recipe) => recipe.id).toList(),
            groceryIds: groceries.map((grocery) => grocery.id!).toList());

        print(uData);

        await model
            .updateMeal(widget.plan.mealPlanMenu.days != null ? uData : data);

        btnNotifier.value = false;
        context.showSuccessSnackBar("Success");
        Navigator.pop(context);
      } else {
        context.showErrorSnackBar("Meal plan or meal plan ID is null.");
      }
    } catch (error) {
      context.showErrorSnackBar(error);
    } finally {
      btnNotifier.value = false;
    }
  }
}
