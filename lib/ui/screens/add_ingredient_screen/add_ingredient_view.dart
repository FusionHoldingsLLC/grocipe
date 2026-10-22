// ignore_for_file: must_be_immutable, use_build_context_synchronously, avoid_print, unused_local_variable
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/helper/size_config/size_config.dart';
import 'package:grocipe/models/recipe.dart';
import 'package:grocipe/helper/third_party/cloudinary.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/models/recipe_flow/add_instruction.dart';
import 'package:grocipe/models/recipe_flow/ingredient.dart';
import 'package:grocipe/models/recipe_flow/instruction.dart';
import 'package:grocipe/models/recipe_flow/nutrition.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/ui/provider/recipe_provider.dart';
import 'package:grocipe/ui/screens/onboarding_detail_screen/widget/app_progress_indicator.dart';
import 'package:grocipe/ui/screens/receipe_screen/local_widgets/add_content.dart';
import 'package:grocipe/ui/screens/receipe_screen/local_widgets/add_ingredient.dart';
import 'package:grocipe/ui/screens/receipe_screen/local_widgets/add_instruction.dart';
import 'package:grocipe/ui/screens/receipe_screen/local_widgets/add_nutriction.dart';
import 'package:grocipe/ui/screens/receipe_screen/local_widgets/edit_ingredient.dart';
import 'package:grocipe/ui/screens/receipe_screen/local_widgets/edit_instruction.dart';
import 'package:grocipe/ui/screens/receipe_screen/local_widgets/edit_nutrition.dart';
import 'package:provider/provider.dart';

class AddIngredient extends StatefulWidget {
  AddIngredient({super.key, this.updateRecipe});
  Recipe? updateRecipe;
  @override
  State<AddIngredient> createState() => _AddIngredientState();
}

class _AddIngredientState extends State<AddIngredient> with Validators {
  TextEditingController servings = TextEditingController();
  TextEditingController cuisine = TextEditingController();
  TextEditingController category = TextEditingController();
  Duration? prepTime;
  Duration? cookTime;
  final btnNotifer = ValueNotifier(false);
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var recipeProvider = Provider.of<RecipeProvider>(context, listen: false);

      var recipeData = recipeProvider.addRecipeData;
      if (recipeData != null) {
        servings.text = recipeData.servings;
        cuisine.text = recipeData.cuisine;
      }
      var recipeInstuction = recipeProvider.addInstructionData;

      if (recipeInstuction != null) {
        prepTime = recipeInstuction.prepTime;
        cookTime = recipeInstuction.cookTime;
        prepTime = recipeInstuction.prepTime;
        meal = recipeInstuction.category;
      }

      if (widget.updateRecipe != null) {
        prepTime = Duration(minutes: widget.updateRecipe?.prepTime ?? 0);
        cookTime = Duration(minutes: widget.updateRecipe?.cookTime ?? 0);
        category.text =
            (widget.updateRecipe?.mealTypes.first.name.capitalizeFirst ?? "");
        setState(() {
          meal =
              (widget.updateRecipe?.mealTypes.first.name.capitalizeFirst ?? "");
        });
      }

      setState(() {});
    });
  }

  final recipeForm = GlobalKey<FormState>();
  String? meal;
  @override
  Widget build(BuildContext context) {
    var recipeProvider = Provider.of<RecipeProvider>(context, listen: true);
    var l10n = context.l10n;

    List<String> mealType = [
      l10n.breakfast,
      l10n.lunch,
      l10n.dinner,
      l10n.others
    ];
    return BlocConsumer<RecipeBloc, RecipeState>(
      listener: (context, state) {
        btnNotifer.value = (state is RecipeProcessing && state.isCreating) ||
            (state is RecipeProcessing && state.isUpdating);
        // btnNotifer.value = ;
        if (state is RecipesLoaded) {
          // context.showSuccessSnackBar(state.message);
          context.goNamed(Routes.mainScreen);
          recipeProvider.clear();
        } else if (state is RecipeError) {
          context.showErrorSnackBar(state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: const AppBackButton(),
            leadingWidth: 100,
            title: Text(
              l10n.addRecipeTitle,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const AppLinearProgressIndicator(length: 2, completed: 2),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Form(
                      key: recipeForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpansionTileCard(
                            contentPadding: EdgeInsets.zero,
                            title: Text(l10n.ingredients),
                            elevation: 0,
                            initiallyExpanded: true,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          recipeProvider.ingredients.length *
                                              60,
                                      child: ListView.builder(
                                        itemCount:
                                            recipeProvider.ingredients.length,
                                        itemBuilder: (context, index) {
                                          Ingredient ingredient =
                                              recipeProvider.ingredients[index];
                                          return Slidable(
                                            startActionPane: ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed:
                                                      (BuildContext context) {
                                                    recipeProvider
                                                        .deleteIngredient(
                                                            index);
                                                    setState(() {});
                                                  },
                                                  backgroundColor:
                                                      const Color(0xFFFE4A49),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.delete,
                                                  label: 'Delete',
                                                ),
                                              ],
                                            ),
                                            endActionPane: ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  flex: 2,
                                                  onPressed: (BuildContext
                                                      context) async {
                                                    await showModalBottomSheet<
                                                        void>(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .vertical(
                                                          top: Radius.circular(
                                                              20),
                                                        ),
                                                      ),
                                                      builder: (context) =>
                                                          EditIngredientPopup(
                                                        index: index,
                                                      ),
                                                    );
                                                  },
                                                  backgroundColor:
                                                      const Color(0xFF7BC043),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.edit,
                                                  label: 'Edit',
                                                ),
                                              ],
                                            ),
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              leading: Text(
                                                // (ingredient.index + 1).toString(),
                                                (index + 1).toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              title: SizedBox(
                                                child: Text(
                                                  ingredient.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              trailing: SizedBox(
                                                width: 120,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        ingredient.detail,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: Palette.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: IconButton(
                                                          onPressed: () {
                                                            recipeProvider
                                                                .deleteIngredient(
                                                                    index);
                                                            setState(() {});
                                                          },
                                                          icon: Icon(
                                                              Icons
                                                                  .remove_circle_outline_outlined,
                                                              color: context
                                                                  .primaryColor)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    AddContent(
                                      text: l10n.addAnIngredient,
                                      onTap: () async {
                                        showModalBottomSheet(
                                            elevation: 50,
                                            backgroundColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                            ),
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) =>
                                                IngredientPopup());

                                        // await showModalBottomSheet<void>(
                                        //   context: context,
                                        //   shape: const RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.vertical(
                                        //       top: Radius.circular(20),
                                        //     ),
                                        //   ),
                                        //   builder: (context) =>
                                        //       const IngredientPopup(),
                                        // );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          ExpansionTileCard(
                            contentPadding: EdgeInsets.zero,
                            title: Text(l10n.instructions),
                            elevation: 0,
                            initiallyExpanded: true,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          recipeProvider.instructions.length *
                                              60,
                                      child: ListView.builder(
                                        itemCount:
                                            recipeProvider.instructions.length,
                                        itemBuilder: (context, index) {
                                          Instruction ingredient =
                                              recipeProvider
                                                  .instructions[index];
                                          return Slidable(
                                            startActionPane: ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed:
                                                      (BuildContext context) {
                                                    recipeProvider
                                                        .deleteInstruction(
                                                            index);
                                                    setState(() {});
                                                  },
                                                  backgroundColor:
                                                      const Color(0xFFFE4A49),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.delete,
                                                  label: l10n.delete,
                                                ),
                                              ],
                                            ),
                                            endActionPane: ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  flex: 2,
                                                  onPressed: (BuildContext
                                                      context) async {
                                                    await showModalBottomSheet(
                                                        elevation: 50,
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                        ),
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        builder: (context) =>
                                                            EditInstructionPopup(
                                                              index: index,
                                                            ));
                                                    // await showModalBottomSheet<
                                                    //     void>(
                                                    //   context: context,
                                                    //   shape:
                                                    //       const RoundedRectangleBorder(
                                                    //     borderRadius:
                                                    //         BorderRadius
                                                    //             .vertical(
                                                    //       top: Radius.circular(
                                                    //           20),
                                                    //     ),
                                                    //   ),
                                                    //   builder: (context) =>
                                                    //       EditInstructionPopup(
                                                    //     index: index,
                                                    //   ),
                                                    // );
                                                  },
                                                  backgroundColor:
                                                      const Color(0xFF7BC043),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.edit,
                                                  label: l10n.edit,
                                                ),
                                              ],
                                            ),
                                            child: ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              leading: Text(
                                                (ingredient.order + 1)
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              title: Text(
                                                ingredient.title,
                                              ),
                                              trailing: SizedBox(
                                                width: 100,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        ingredient.duration !=
                                                                null
                                                            ? "${ingredient.duration?.inMinutes} ${l10n.minutes}"
                                                            : "",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: Palette.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: IconButton(
                                                          onPressed: () {
                                                            recipeProvider
                                                                .deleteInstruction(
                                                                    index);
                                                            setState(() {});
                                                          },
                                                          icon: Icon(
                                                              Icons
                                                                  .remove_circle_outline_outlined,
                                                              color: context
                                                                  .primaryColor)),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    AddContent(
                                      text: l10n.addAnInstruction,
                                      onTap: () async {
                                        await showModalBottomSheet(
                                            elevation: 50,
                                            backgroundColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                            ),
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) =>
                                                InstructionPopup());
                                        // await showModalBottomSheet<void>(
                                        //   context: context,
                                        //   shape: const RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.vertical(
                                        //       top: Radius.circular(20),
                                        //     ),
                                        //   ),
                                        //   builder: (context) =>
                                        //       const InstructionPopup(),
                                        // );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          ExpansionTileCard(
                            contentPadding: EdgeInsets.zero,
                            title: Text(l10n.nutritions),
                            elevation: 0,
                            initiallyExpanded: true,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          recipeProvider.nutritions.length * 60,
                                      child: ListView.builder(
                                        itemCount:
                                            recipeProvider.nutritions.length,
                                        itemBuilder: (context, index) {
                                          Nutrition nutrition =
                                              recipeProvider.nutritions[index];
                                          return Slidable(
                                            startActionPane: ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed:
                                                      (BuildContext context) {
                                                    recipeProvider
                                                        .deleteNutrition(index);
                                                    setState(() {});
                                                  },
                                                  backgroundColor:
                                                      const Color(0xFFFE4A49),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.delete,
                                                  label: l10n.delete,
                                                ),
                                              ],
                                            ),
                                            endActionPane: ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  flex: 2,
                                                  onPressed: (BuildContext
                                                      context) async {
                                                    await showModalBottomSheet(
                                                        elevation: 50,
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                        ),
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        builder: (context) =>
                                                            EditNutritionPopup(
                                                              index: index,
                                                            ));

                                                    // await showModalBottomSheet<
                                                    //     void>(
                                                    //   context: context,
                                                    //   shape:
                                                    //       const RoundedRectangleBorder(
                                                    //     borderRadius:
                                                    //         BorderRadius
                                                    //             .vertical(
                                                    //       top: Radius.circular(
                                                    //           20),
                                                    //     ),
                                                    //   ),
                                                    //   builder: (context) =>
                                                    //       EditNutritionPopup(
                                                    //     index: index,
                                                    //   ),
                                                    // );
                                                  },
                                                  backgroundColor:
                                                      const Color(0xFF7BC043),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.edit,
                                                  label: l10n.edit,
                                                ),
                                              ],
                                            ),
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              title: SizedBox(
                                                child: Text(
                                                  nutrition.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              trailing: SizedBox(
                                                width: 100,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        nutrition.value,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: Palette.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: IconButton(
                                                          onPressed: () {
                                                            recipeProvider
                                                                .deleteNutrition(
                                                                    index);
                                                            setState(() {});
                                                          },
                                                          icon: Icon(
                                                              Icons
                                                                  .remove_circle_outline_outlined,
                                                              color: context
                                                                  .primaryColor)),
                                                    )
                                                  ],
                                                ),
                                                // Text(
                                                //   nutrition.value,
                                                //   overflow: TextOverflow.ellipsis,
                                                //   style: TextStyle(
                                                //     color: Palette.grey,
                                                //   ),
                                                // ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    AddContent(
                                      text: l10n.addANutrition,
                                      onTap: () async {
                                        // await showModalBottomSheet<void>(
                                        //   context: context,
                                        //   shape: const RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.vertical(
                                        //       top: Radius.circular(20),
                                        //     ),
                                        //   ),
                                        //   builder: (context) =>
                                        //       const NutritionPopup(),
                                        // );

                                        await showModalBottomSheet(
                                            elevation: 50,
                                            backgroundColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                            ),
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) =>
                                                NutritionPopup());
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Gap(30),
                          const Gap(200),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            color: Palette.white,
            height: 100,
            child: Center(
              child: SizedBox(
                width: SizeConfig.screenWidth * .9,
                child: AppElevatedButton(
                  notifier: btnNotifer,
                  onPressed: () {
                    if (meal != null && prepTime != null && cookTime != null) {
                      if (!recipeForm.currentState!.validate()) return;

                      recipeProvider.inputinstructionData(
                        AddInstructionData(
                          ingredients: recipeProvider.ingredients,
                          instructions: recipeProvider.instructions,
                          nutritions: recipeProvider.nutritions,
                          category: meal ?? "",
                          prepTime: prepTime ?? const Duration(minutes: 0),
                          cookTime: cookTime ?? const Duration(minutes: 0),
                        ),
                      );

                      if (widget.updateRecipe == null) {
                        context.read<RecipeBloc>().add(
                              CreateRecipeEvent(
                                  addRecipeData: recipeProvider.addRecipeData!,
                                  addInstructionData:
                                      recipeProvider.addInstructionData!,
                                  mealType: meal ?? ""),
                            );
                      } else {
                        updateRecipe(recipeProvider);
                      }
                    } else {
                      context.showErrorSnackBar("fill all fields");
                    }
                  },
                  style: context.elevatedButtonTheme.style?.copyWith(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(context.primaryColor),
                  ),
                  child:
                      Text(widget.updateRecipe == null ? l10n.next : "Update"),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  updateRecipe(RecipeProvider recipeProvider) async {
    if ((recipeProvider.addRecipeData?.image.isEmpty) ?? false) {
      context.showErrorSnackBar("No Image");
    }
    btnNotifer.value = true;
    var url = '';
    if (widget.updateRecipe?.recipeImages[0].imageData.toString() !=
        recipeProvider.addRecipeData?.image) {
      var imageUrl = await CloudinaryDev.uploadPicture(
        path: recipeProvider.addRecipeData?.image ?? "",
        folder: 'Recipe',
        fileName: widget.updateRecipe?.recipeImages[0].id.toString(),
      );
      if (imageUrl is Map) {
        context.showErrorSnackBar('Image Upload failed');
        btnNotifer.value = false;
        return;
      } else {
        url = imageUrl;
        btnNotifer.value = false;
      }
    } else {
      url = recipeProvider.addRecipeData?.image ?? "";
      btnNotifer.value = false;
    }

    print(meal);
    Map<String, dynamic> req = {
      'id': widget.updateRecipe?.id,
      // 'user_id': 1,
      'original_recipe_id': widget.updateRecipe?.originalRecipeId,
      "name": recipeProvider.addRecipeData?.name,
      "diet": widget.updateRecipe?.diet,

      "author": widget.updateRecipe?.author,
      "cuisine": cuisine.text,
      "prep_time": prepTime?.inMinutes,
      "cook_time": cookTime?.inMinutes,
      "total_time": prepTime?.inMinutes ?? 0 + (cookTime?.inMinutes ?? 0),
      "servings": int.parse(servings.text),
      "rating": null,
      "video_url": null,
      "url": null,
      "creation_method": "manual",
      "is_public": false,
      // "details": (addRecipeData.description),
      "meal_types": [
        {"name": meal, 'id': widget.updateRecipe?.mealTypes[0].id},
      ],
      "date_updated": DateTime.now().toIso8601String(),
      "category": meal,
      "created_mode": widget.updateRecipe?.creationMethod,

      "ingredients": recipeProvider.ingredients
          .map((ingredient) => ingredient.toMap())
          .toList(),
      "instructions":
          recipeProvider.instructions.map((ins) => ins.toMap()).toList(),
      "nutritional_facts": widget.updateRecipe?.nutritionalFacts
          .map((ins) => ins.toJson())
          .toList(),
      "recipe_images": [
        {"image_data": url, 'id': widget.updateRecipe?.recipeImages[0].id}
      ],
      "health_reports": widget.updateRecipe?.healthReports
          .map((ins) => ins.toJson())
          .toList(),
    };
    context.read<RecipeBloc>().add(UpdateRecipeEvent(EditReq: req));
  }
}
