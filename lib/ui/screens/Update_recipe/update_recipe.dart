// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/helper/third_party/cloudinary.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/image_utils.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/models/ingredient.dart';
import 'package:grocipe/models/instruction.dart';
import 'package:grocipe/models/nutrition.dart';
import 'package:grocipe/models/recipe.dart';
import 'package:grocipe/ui/screens/receipe_screen/local_widgets/add_content.dart';
import 'package:grocipe/ui/screens/receipe_screen/local_widgets/add_ingredient.dart';
import 'package:grocipe/ui/screens/receipe_screen/local_widgets/add_instruction.dart';
import 'package:grocipe/ui/screens/receipe_screen/local_widgets/add_nutriction.dart';

class UpdateRecipe extends StatefulWidget {
  const UpdateRecipe({super.key, required this.recipe});
// static String id = ''
  final Recipe recipe;

  @override
  State<UpdateRecipe> createState() => _UpdateRecipeState();
}

class _UpdateRecipeState extends State<UpdateRecipe> with Validators {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  String _imageFile = '';
  bool isOffline = false;
  //--------------
  TextEditingController servings = TextEditingController();
  TextEditingController cuisine = TextEditingController();
  // TextEditingController category = TextEditingController();
  Duration? prepTime;
  Duration? cookTime;

  //----------
  List<Ingredient> ingredients = [];
  List<Instruction2> instructions = [];
  List<NutritionalFact> nutritions = [];
  void _pickImageFromGallery() async {
    try {
      _imageFile = (await ImageUtils.pickImage(95))?.path ?? '';
    } catch (e) {
      context.showErrorSnackBar("Invalid Image");
    }
  }

  final btnNotifier = ValueNotifier(false);
  String? meal;
  final updateRecipeForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Recipe recipe = widget.recipe;
    print(recipe.toJson());
    name.text = recipe.name;
    _imageFile = recipe.recipeImages[0].imageData;
    servings.text = recipe.servings.toString();
    cuisine.text = recipe.cuisine ?? '';

    prepTime = Duration(minutes: recipe.prepTime);
    cookTime = Duration(minutes: recipe.cookTime);
    ingredients = recipe.ingredients ?? [];
    instructions = recipe.instructions;
    nutritions = recipe.nutritionalFacts;
    print(widget.recipe.toString());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Recipe recipe = widget.recipe;

    var l10n = context.l10n;
    List<String> mealType = [
      l10n.breakfast,
      l10n.lunch,
      l10n.dinner,
      l10n.others
    ];
    print(mealType);
    print(recipe.mealTypes[0].name);
    meal = mealType
            .map((e) => e.toString().toLowerCase())
            .toList()
            .contains(recipe.mealTypes[0].name)
        ? recipe.mealTypes[0].name.capitalizeFirst
        : l10n.others;
  }

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    List<String> mealType = [
      l10n.breakfast,
      l10n.lunch,
      l10n.dinner,
      l10n.others
    ];
    return BlocConsumer<RecipeBloc, RecipeState>(
      listener: (context, state) {
        btnNotifier.value = state is RecipeProcessing && state.isUpdating;
        if (state is RecipesLoaded) {
          // context.showSuccessSnackBar(state.message);
          context.pop();
        } else if (state is RecipeError) {
          context.showErrorSnackBar(state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: const AppBackButton(),
            leadingWidth: 100,
            title: const Text(
              "Update Recipe",
            ),
          ),
          body: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: updateRecipeForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_imageFile.isNotEmpty) ...[
                        const Gap(20),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              height: 221,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: isOffline
                                    ? Image.file(
                                        File(_imageFile),
                                        // fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey,
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.person,
                                                size: 50,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Image.network(
                                        _imageFile,
                                        // fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey,
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.person,
                                                size: 50,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: -20,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _imageFile = '';
                                  });
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  size: 30,
                                  // color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        GestureDetector(
                          onTap: () {
                            _pickImageFromGallery();
                          },
                          child: DottedBorder(
                            color: Colors.black,
                            strokeWidth: 1,
                            radius: Radius.circular(20),
                            dashPattern: const [4, 10],
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              height: 221,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo_size_select_actual_rounded,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 60,
                                  ),
                                  Text(
                                    "Add image",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    "You can remove an image by longing pressing it",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Colors.grey,
                                        ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                      const Gap(15),
                      AppInputField(
                        title: "Recipe Name ",
                        child: TextFormField(
                          controller: name,
                          validator: validateName,
                          decoration: const InputDecoration(
                            hintText: "Enter Name",
                          ),
                        ),
                      ),
                      const Gap(15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpansionTileCard(
                            contentPadding: EdgeInsets.zero,
                            title: Text(l10n.ingredients),
                            elevation: 0,
                            initiallyExpanded: true,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: ingredients.length * 60,
                                      child: ListView.builder(
                                        itemCount: ingredients.length,
                                        itemBuilder: (context, index) {
                                          Ingredient ingredient =
                                              ingredients[index];
                                          return ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: Text(
                                              (ingredient.id + 1).toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                            title: Text(
                                              ingredient.name,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    AddContent(
                                      text: "Add an ingredient",
                                      onTap: () async {
                                        await showDialog<void>(
                                          context: context,
                                          builder: (context) =>
                                              const IngredientPopup(),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          ExpansionTileCard(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              "Instructions",
                            ),
                            elevation: 0,
                            initiallyExpanded: true,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: instructions.length * 60,
                                      child: ListView.builder(
                                        itemCount: instructions.length,
                                        itemBuilder: (context, index) {
                                          Instruction2 ingredient =
                                              instructions[index];
                                          return ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: Text(
                                              (ingredient.order + 1).toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                            title: Text(
                                              ingredient.instruction,
                                            ),
                                            trailing: Text(
                                              ingredient.duration != null
                                                  ? "${ingredient.duration} minutes"
                                                  : ingredient.duration
                                                      .toString(),
                                              style: TextStyle(
                                                color: Palette.grey,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    AddContent(
                                      text: "Add an Instruction",
                                      onTap: () async {
                                        await showDialog<void>(
                                          context: context,
                                          builder: (context) =>
                                              const InstructionPopup(),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          ExpansionTileCard(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              "Nutritions",
                            ),
                            elevation: 0,
                            initiallyExpanded: true,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: nutritions.length * 60,
                                      child: ListView.builder(
                                        itemCount: nutritions.length,
                                        itemBuilder: (context, index) {
                                          NutritionalFact ingredient =
                                              nutritions[index];
                                          return ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              ingredient.name,
                                            ),
                                            trailing: SizedBox(
                                              width: 100,
                                              child: Text(
                                                ingredient.value,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Palette.grey,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    AddContent(
                                      text: "Add a Nutrition",
                                      onTap: () async {
                                        await showDialog<void>(
                                          context: context,
                                          builder: (context) =>
                                              const NutritionPopup(),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Gap(10),
                          AppInputField(
                            title: "Number of servings",
                            child: TextFormField(
                              controller: servings,
                              validator: validateDigit,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "Number of servings",
                              ),
                            ),
                          ),
                          const Gap(10),
                          AppInputField(
                            title: "Cuisine",
                            child: TextFormField(
                              controller: cuisine,
                              validator: validateName,
                              decoration: const InputDecoration(
                                hintText: "Enter Cuisine",
                              ),
                            ),
                          ),
                          const Gap(10),
                          Text(
                            "Meal Type",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Gap(5),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Palette.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Palette.grey),
                            ),
                            child: DropdownButton<String>(
                              underline: Container(),
                              // hint: Text(""),
                              value: meal,
                              isExpanded: true,
                              onChanged: (newValue) {
                                setState(() {
                                  meal = newValue;
                                });
                              },
                              items: mealType.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const Gap(10),
                          Text(
                            "Prep Time",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Gap(5),
                          ListTile(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: const Icon(CupertinoIcons.clock),
                            title: Text(prepTime == null
                                ? "Duration"
                                : "${prepTime!.inMinutes} minutes"),
                            trailing: prepTime != null
                                ? const Icon(Icons.chevron_right)
                                : const Icon(Icons.edit),
                            onTap: () async {
                              var resultingDuration = await showDurationPicker(
                                context: context,
                                initialTime:
                                    prepTime ?? const Duration(minutes: 30),
                                // snapToMins: 20,
                              );
                              setState(() {
                                prepTime = resultingDuration;
                              });
                            },
                          ),
                          const Gap(10),
                          Text(
                            "Cook Time",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Gap(5),
                          ListTile(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: const Icon(CupertinoIcons.clock),
                            title: Text(cookTime == null
                                ? "Duration"
                                : "${cookTime!.inMinutes} minutes"),
                            trailing: cookTime != null
                                ? const Icon(Icons.chevron_right)
                                : const Icon(Icons.edit),
                            onTap: () async {
                              var resultingDuration = await showDurationPicker(
                                context: context,
                                initialTime:
                                    cookTime ?? const Duration(minutes: 30),
                                // snapToMins: 20,
                              );
                              setState(() {
                                cookTime = resultingDuration;
                              });
                            },
                          ),
                          const Gap(200),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomSheet: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 120,
            child: Center(
              child: AppElevatedButton(
                notifier: btnNotifier,
                onPressed: updateRecipe,
                child: const Text("Update Recipe"),
              ),
            ),
          ),
        );
      },
    );
  }

  updateRecipe() async {
    if (!updateRecipeForm.currentState!.validate()) return;
    if (_imageFile.isEmpty) {
      context.showErrorSnackBar("No Image");
    }
    var url = '';
    if (widget.recipe.recipeImages[0].imageData.toString() != _imageFile) {
      var imageUrl = await CloudinaryDev.uploadPicture(
        path: _imageFile,
        folder: 'Recipe',
        fileName: widget.recipe.recipeImages[0].id.toString(),
      );
      if (imageUrl is Map) {
        context.showErrorSnackBar('Image Upload failed');
        return;
      } else {
        url = imageUrl;
      }
    } else {
      url = _imageFile;
    }
    print(meal);
    Map<String, dynamic> req = {
      'id': widget.recipe.id,
      'user_id': 1,
      'original_recipe_id': widget.recipe.originalRecipeId,
      "name": name.text,
      "diet": widget.recipe.diet,
      "author": widget.recipe.author,
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
        // {"name": meal, 'id': widget.recipe.mealTypes[0].id},
      ],
      "date_updated": DateTime.now().toIso8601String(),
      "category": meal,

      "ingredients":
          ingredients.map((ingredient) => ingredient.toApiJson()).toList(),
      "instructions": instructions.map((ins) => ins.toMap()).toList(),
      "nutritional_facts":
          widget.recipe.nutritionalFacts.map((ins) => ins.toJson()).toList(),
      "recipe_images": [
        {"image_data": url, 'id': widget.recipe.recipeImages[0].id}
      ],
      "health_reports":
          widget.recipe.healthReports.map((ins) => ins.toJson()).toList(),
    };
    context.read<RecipeBloc>().add(UpdateRecipeEvent(EditReq: req));
  }
}
