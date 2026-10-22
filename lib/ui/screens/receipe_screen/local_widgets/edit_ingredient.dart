import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/models/recipe_flow/ingredient.dart';
import 'package:grocipe/ui/provider/recipe_provider.dart';
import 'package:provider/provider.dart';

class EditIngredientPopup extends StatefulWidget {
  const EditIngredientPopup({super.key, required this.index});
  final int index;
  @override
  State<EditIngredientPopup> createState() => _EditIngredientPopupState();
}

class _EditIngredientPopupState extends State<EditIngredientPopup>
    with Validators {
  final TextEditingController _qController = TextEditingController();
  final TextEditingController _uController = TextEditingController();
  bool loading = false;
  final formKay = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    var recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    _qController.text = recipeProvider.ingredients[widget.index].name;
    _uController.text = recipeProvider.ingredients[widget.index].detail;
  }

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
              // height: 300,
              child: Form(
                key: formKay,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("Add Ingredient"),
                      const Gap(20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppInputField(
                            title: "Ingredient name",
                            child: TextFormField(
                              controller: _qController,
                              validator: validateName,
                              decoration: const InputDecoration(
                                hintText: "Ingredient name",
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          AppInputField(
                            title: "Details",
                            child: TextFormField(
                              controller: _uController,
                              validator: validateName,
                              maxLines: 2,
                              decoration: const InputDecoration(
                                hintText: "Details",
                              ),
                            ),
                          ),
                        ],
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
                                if (!formKay.currentState!.validate()) return;
                                recipeProvider.editIngredient(
                                    Ingredient(
                                        name: _qController.text,
                                        detail: _uController.text,
                                        index: recipeProvider
                                            .ingredients[widget.index].index,
                                        id: recipeProvider
                                            .ingredients[widget.index].id),
                                    widget.index);
                                context.pop();
                              },
                              style:
                                  context.elevatedButtonTheme.style?.copyWith(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
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
