// ignore_for_file: public_member_api_docs, sort_constructors_first, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/models/recipe_flow/nutrition.dart';
import 'package:grocipe/ui/provider/recipe_provider.dart';
import 'package:provider/provider.dart';

class EditNutritionPopup extends StatefulWidget {
  const EditNutritionPopup({super.key, required this.index});
  final int index;
  @override
  State<EditNutritionPopup> createState() => _EditNutritionPopupState();
}

class _EditNutritionPopupState extends State<EditNutritionPopup>
    with Validators {
  final TextEditingController _qController = TextEditingController();
  final TextEditingController _uController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    var recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    _qController.text = recipeProvider.nutritions[widget.index].name;
    _uController.text = recipeProvider.nutritions[widget.index].value;
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var recipeProvider = Provider.of<RecipeProvider>(context, listen: true);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("Add Nutrition"),
                    const Gap(20),
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppInputField(
                            title: "Nutririon Name",
                            child: TextFormField(
                              controller: _qController,
                              validator: validateName,
                              decoration: const InputDecoration(
                                hintText: "Name",
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          AppInputField(
                            title: "Details",
                            child: TextFormField(
                              controller: _uController,
                              validator: validateName,
                              decoration: const InputDecoration(
                                hintText: "Details",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Expanded(
                        //     child: CustomTextButton(
                        //         text: "Cancel",
                        //         onPressed: () {
                        //           context.pop();
                        //         })),
                        Expanded(
                          child: AppElevatedButton(
                            notifier: ValueNotifier(false),
                            onPressed: () {
                              if (!formKey.currentState!.validate()) return;
                              recipeProvider.editNutrition(
                                  Nutrition(
                                      name: _qController.text,
                                      value: _uController.text),
                                  widget.index);
                              context.pop();
                            },
                            style: context.elevatedButtonTheme.style?.copyWith(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  context.primaryColor),
                            ),
                            child: const Text("Edit"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: -10,
              right: -10,
              child: IconButton(
                icon: Icon(Icons.cancel),
                color: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
