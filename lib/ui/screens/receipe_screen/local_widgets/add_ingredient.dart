// ignore_for_file: library_prefixes, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/app/app_widgets/custom_text_button.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/models/grocery_list.dart';
import 'package:grocipe/models/recipe_flow/ingredient.dart';
import 'package:grocipe/models/states/app_state.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/ui/provider/grocery_provider/grocery_provider.dart';
import 'package:grocipe/ui/provider/grocery_provider/recipe_provider.dart'
    as myRecipeProvider;
import 'package:grocipe/ui/provider/recipe_provider.dart';

import 'package:provider/provider.dart' as provider;

class IngredientPopup extends ConsumerStatefulWidget {
  const IngredientPopup({Key? key}) : super(key: key);

  @override
  ConsumerState<IngredientPopup> createState() => _IngredientPopupState();
}

class _IngredientPopupState extends ConsumerState<IngredientPopup>
    with Validators {
  final TextEditingController _qController = TextEditingController();
  final TextEditingController _uController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final btnNotifier = ValueNotifier(false);
  Grocery? selectedGrocery;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(groceryProvider.notifier).searchGrocery('', '');
    });
  }

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    var recipeProvider =
        provider.Provider.of<RecipeProvider>(context, listen: true);

    return Container(
      padding: const EdgeInsets.all(20),
      // height: 300,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              // height: 300,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(l10n.add_ingredient),
                    const Gap(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppInputField(
                          title: l10n.ingredient_name,
                          child: Consumer(
                            builder: (context, watch, child) {
                              final groceryState = ref.watch(groceryProvider);
                              return Column(
                                children: [
                                  TextFormField(
                                    validator: validateName,
                                    controller: _qController,
                                    onChanged: (value) {
                                      if (value.length >= 3) {
                                        selectedGrocery = null;
                                        ref
                                            .read(groceryProvider.notifier)
                                            .searchGrocery(value, '');
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: l10n.hint_ingredient_name,
                                    ),
                                  ),
                                  if (groceryState is ListAppState<Grocery>)
                                    if (groceryState.data.isNotEmpty)
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    context.colors.greyOutline,
                                                width: 1.5),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        constraints: const BoxConstraints(
                                            maxHeight: 100),
                                        child: ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              const Gap(1),
                                          itemCount: groceryState.data.length,
                                          itemBuilder: (context, index) {
                                            final grocery =
                                                groceryState.data[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  _qController.text =
                                                      grocery.itemName ?? "";
                                                  selectedGrocery = grocery;
                                                  ref
                                                      .read(groceryProvider
                                                          .notifier)
                                                      .searchGrocery('', '');
                                                },
                                                child: Text(
                                                  grocery.itemName ?? "",
                                                  style: context
                                                      .textTheme.titleMedium,
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
                        const SizedBox(height: 20.0),
                        AppInputField(
                          title: l10n.details,
                          child: TextFormField(
                            controller: _uController,
                            validator: validateName,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: l10n.hint_details,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AppElevatedButton(
                            notifier: btnNotifier,
                            onPressed: () {
                              if (!formKey.currentState!.validate()) return;

                              if (selectedGrocery == null) {
                                context.showMessage(
                                    "Please select a grocery item.");
                                return;
                              }

                              recipeProvider.addIngredient(
                                Ingredient(
                                  name: selectedGrocery?.itemName ??
                                      _qController.text,
                                  detail: _uController.text,
                                  index: selectedGrocery?.id ?? 0,
                                  id: 0,
                                  groceryId: selectedGrocery?.id ?? 0,
                                ),
                              );
                              Navigator.pop(context);
                            },
                            style: context.elevatedButtonTheme.style?.copyWith(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  context.primaryColor),
                            ),
                            child: Text(l10n.add),
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
