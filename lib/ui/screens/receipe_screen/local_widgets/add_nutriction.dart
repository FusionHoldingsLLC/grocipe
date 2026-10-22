// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/models/recipe_flow/nutrition.dart';
import 'package:grocipe/ui/provider/recipe_provider.dart';
import 'package:provider/provider.dart';

class NutritionPopup extends StatefulWidget {
  const NutritionPopup({super.key});
  @override
  State<NutritionPopup> createState() => _NutritionPopupState();
}

class _NutritionPopupState extends State<NutritionPopup> {
  final TextEditingController _qController = TextEditingController();
  final TextEditingController _uController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var recipeProvider = Provider.of<RecipeProvider>(context, listen: true);
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            SizedBox(
              // height: 300,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      l10n.addANutrition,
                      style: context.textTheme.titleMedium,
                    ),
                    const Gap(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppInputField(
                          title: "Nutririon Name",
                          child: TextFormField(
                            controller: _qController,
                            decoration: InputDecoration(
                              hintText: l10n.name,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        AppInputField(
                          title: l10n.details,
                          child: TextFormField(
                            controller: _uController,
                            decoration: InputDecoration(
                              hintText: l10n.details,
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
                        //         text: l10n.cancel,
                        //         onPressed: () {
                        //           context.pop();
                        //         })),
                        Expanded(
                          child: AppElevatedButton(
                            notifier: ValueNotifier(false),
                            onPressed: () {
                              recipeProvider.addNutrition(
                                Nutrition(
                                    name: _qController.text,
                                    value: _uController.text),
                              );
                              context.pop();
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
