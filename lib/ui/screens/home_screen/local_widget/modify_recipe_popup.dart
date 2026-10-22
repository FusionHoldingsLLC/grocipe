// ignore_for_file: library_prefixes, unused_catch_clause, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/image_utils.dart';
import 'package:grocipe/models/recipe.dart';
import 'package:grocipe/models/recipe_flow/add_recipe.dart';
import 'package:grocipe/ui/provider/recipe_provider.dart';
import 'package:grocipe/models/recipe_flow/ingredient.dart'
    as recipeFlowIngredient;
import 'package:grocipe/models/recipe_flow/nutrition.dart'
    as recipeFlowNutrition;
import 'package:grocipe/models/recipe_flow/instruction.dart'
    as recipeFlowInstruction;

class ModifyRecipe extends StatefulWidget {
  const ModifyRecipe({super.key, required this.recipe});
  final Recipe recipe;

  @override
  State<ModifyRecipe> createState() => _ModifyRecipeState();
}

class _ModifyRecipeState extends State<ModifyRecipe> {
  final btnNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Palette.grey.withOpacity(0.3),
                child: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: Image.asset('assets/images/icons/cancel.png'),
                ),
              ),
            ],
          ),
          ListTile(
              onTap: () async {
                btnNotifier.value = true;
                final recipeProvider = context.read<RecipeProvider>();

                recipeProvider.clear();

                File? image;

                try {
                  image = await ImageUtils.downloadImage(
                      widget.recipe.recipeImages.first.imageData);
                } on Exception catch (e) {
                  btnNotifier.value = false;
                  return;
                }

                recipeProvider.inputRecipeData(
                  AddRecipeData(
                    image: image.path,
                    name: widget.recipe.name,
                    description: widget.recipe.note ?? "",
                    servings: (widget.recipe.servings).toString(),
                    cuisine: widget.recipe.cuisine ?? "",
                  ),
                );

                final ingredients = widget.recipe.ingredients;
                if (ingredients != null) {
                  for (int i = 0; i < ingredients.length; i++) {
                    final ingredient = ingredients[i];
                    recipeProvider.addIngredient(
                      recipeFlowIngredient.Ingredient(
                          name: ingredient.name,
                          detail: ingredient.detail ?? "",
                          index: ingredient.ingredientId,
                          id: ingredient.id,
                          groceryId: ingredient.ingredientId),
                    );
                  }

                  // Add instructions to the provider with index
                  final instructions = widget.recipe.instructions;
                  for (int i = 0; i < instructions.length; i++) {
                    final instruction = instructions[i];
                    recipeProvider.addInstruction(
                      recipeFlowInstruction.Instruction(
                          title: instruction.instruction,
                          details: "",
                          id: instruction.id,
                          order: recipeProvider.instructions.length,
                          duration:
                              Duration(minutes: instruction.duration ?? 0)),
                    );
                  }

                  // Add nutrition facts to the provider with index
                  final nutritionalFacts = widget.recipe.nutritionalFacts;
                  for (int i = 0; i < nutritionalFacts.length; i++) {
                    final nutrition = nutritionalFacts[i];
                    recipeProvider.addNutrition(
                      recipeFlowNutrition.Nutrition(
                        name: nutrition.name,
                        value: nutrition.value,
                      ),
                    );
                  }
                  context.pop();
                  context.go(
                    '/main_screen/add/recipe',
                    extra: widget.recipe,
                  );
                  btnNotifier.value = false;
                }
              },
              leading: const SvgRenderWidget(svgPath: "assets/svgs/edit.svg"),
              title: const Text(
                'Edit Recipe',
              ),
              trailing: ValueListenableBuilder(
                  valueListenable: btnNotifier,
                  builder: (_, value, __) => btnNotifier.value
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            )
                          ],
                        )
                      : const SizedBox.shrink())),
          const Divider(),
          ListTile(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'Are you sure you want to delete "${widget.recipe.name}"?',
                          style: context.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'This item will be deleted immediately. You cannot undo this action.',
                          style: context.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.pink),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<RecipeBloc>().add(
                                      DeleteRecipeEvent(id: widget.recipe.id));
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: context.colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              );
            },
            leading: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
            title: const Text(
              'Delete Recipe',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
