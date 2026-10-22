// ignore_for_file: use_build_context_synchronously, unused_field, no_leading_underscores_for_local_identifiers, avoid_print, must_be_immutable

import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/app/app_widgets/image_render_widget.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/size_config/size_config.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/image_utils.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/models/recipe.dart';
import 'package:grocipe/models/recipe_flow/add_instruction.dart';
import 'package:grocipe/models/recipe_flow/add_recipe.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/ui/provider/recipe_provider.dart';
import 'package:grocipe/ui/screens/onboarding_detail_screen/widget/app_progress_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddReceipe extends StatefulWidget {
  AddReceipe({super.key, this.updateRecipe});
  Recipe? updateRecipe;

  @override
  State<AddReceipe> createState() => _AddReceipeState();
}

class _AddReceipeState extends State<AddReceipe> with Validators {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController servings = TextEditingController();
  TextEditingController cuisine = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  TextEditingController category = TextEditingController();
  Duration? prepTime;
  Duration? cookTime;

  String _imageFile = '';
  String imageUrl = '';
  final recipeForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    var recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    servings.text = "1";
    if (recipeProvider.addRecipeData != null) {
      name.text = recipeProvider.addRecipeData!.name;
      description.text = recipeProvider.addRecipeData!.description;
      _imageFile = recipeProvider.addRecipeData!.image;
      servings.text = recipeProvider.addRecipeData!.servings;
      cuisine.text = recipeProvider.addRecipeData!.cuisine;
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
  }

  final btnNotifier = ValueNotifier(false);
  String? meal = "Select meal type";

  @override
  Widget build(BuildContext context) {
    var recipeProvider = Provider.of<RecipeProvider>(context, listen: true);
    var l10n = context.l10n;

    List<String> mealType = [
      "Select meal type",
      l10n.breakfast,
      "Brunch",
      l10n.lunch,
      l10n.dinner,
      "Drink",
      "Snack",
      l10n.others,
    ];

    void _pickImageFromGallery() async {
      try {
        final pickedImage = await ImageUtils.pickImage(100);

        if (pickedImage?.path != null) {
          setState(() {
            _imageFile = pickedImage!.path;
          });
        }
      } catch (e) {
        print(e.toString());
        context.showErrorSnackBar("Invalid Image");
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: 100,
        title: Text(l10n.addRecipeTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            const AppLinearProgressIndicator(length: 2, completed: 1),
            const Gap(10),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Form(
                    key: recipeForm,
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
                                child: Image.file(
                                  File(_imageFile),
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else if (recipeProvider.imageUrl != null) ...[
                          const Gap(20),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                height: 221,
                                child: ImageRenderWidget.network(
                                  imageUrl: recipeProvider.imageUrl,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: -20,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      recipeProvider.deleteImage();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    size: 30,
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
                              radius: const Radius.circular(40),
                              dashPattern: const [4, 10],
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  height: 200,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.photo_size_select_actual_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        size: 60,
                                      ),
                                      Text(
                                        l10n.addImage,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Text(
                                        l10n.removeImageHint,
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
                          ),
                        ],
                        const Gap(15),
                        AppInputField(
                          title: "Recipe Name ",
                          subTitle: "*",
                          child: TextFormField(
                            controller: name,
                            validator: validateName,
                            decoration: InputDecoration(
                              hintText: l10n.enterNameHint,
                            ),
                          ),
                        ),
                        const Gap(10),
                        NumberOfServingDropdown(
                          controller: servings,
                        ),
                        const Gap(10),
                        AppInputField(
                          title: l10n.cuisine_title,
                          subTitle: "*",
                          child: TextFormField(
                            controller: cuisine,
                            validator: validateName,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: l10n.cuisine_hint,
                            ),
                          ),
                        ),
                        const Gap(15),
                        const Gap(10),
                        AppBorderInputField(
                          title: "Meal Type",
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: DropdownButton<String>(
                              icon:
                                  const Icon(Icons.keyboard_arrow_down_rounded),
                              underline: Container(),
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
                        ),
                        const Gap(10),
                        AppBorderInputField(
                          title: "Prep Time",
                          child: ListTile(
                            tileColor: context.colors.white,
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
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
                        ),
                        const Gap(10),
                        AppBorderInputField(
                          title: "Cook Time",
                          child: ListTile(
                            tileColor: context.colors.white,
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
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
                        ),
                        const Gap(200),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 120,
        child: Center(
          child: SizedBox(
            width: SizeConfig.screenWidth * .9,
            child: AppElevatedButton(
              notifier: btnNotifier,
              onPressed: () {
                if (!recipeForm.currentState!.validate()) return;

                if (name.text.isNotEmpty && _imageFile.isNotEmpty) {
                  recipeProvider.inputRecipeData(
                    AddRecipeData(
                      image: _imageFile,
                      name: name.text,
                      description: description.text,
                      servings: servings.text,
                      cuisine: cuisine.text,
                    ),
                  );

                  recipeProvider.inputinstructionData(
                    AddInstructionData(
                        ingredients: [],
                        nutritions: [],
                        instructions: [],
                        prepTime: prepTime ?? const Duration(minutes: 0),
                        category: meal ?? "",
                        cookTime: cookTime ?? const Duration(minutes: 0)),
                  );

                  context.pushNamed(
                    Routes.addIngredient,
                    extra: widget.updateRecipe,
                  );
                } else {
                  context.showErrorSnackBar("Input image and Recipe name");
                }
              },
              style: context.elevatedButtonTheme.style?.copyWith(
                backgroundColor:
                    MaterialStateProperty.all<Color>(context.primaryColor),
              ),
              child: const Text("Next"),
            ),
          ),
        ),
      ),
    );
  }
}

class NumberOfServingDropdown extends StatefulWidget {
  final TextEditingController controller;

  const NumberOfServingDropdown({super.key, required this.controller});

  @override
  NumberOfServingDropdownState createState() => NumberOfServingDropdownState();
}

class NumberOfServingDropdownState extends State<NumberOfServingDropdown> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    quantity = int.tryParse(widget.controller.text) ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return AppBorderInputField(
      title: "Number Of Serving",
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
