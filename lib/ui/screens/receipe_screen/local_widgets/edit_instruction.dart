// ignore_for_file: prefer_final_fields, unused_field

import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/models/recipe_flow/instruction.dart';
import 'package:grocipe/ui/provider/recipe_provider.dart';
import 'package:provider/provider.dart';

class EditInstructionPopup extends StatefulWidget {
  const EditInstructionPopup({super.key, required this.index});
  final int index;

  @override
  State<EditInstructionPopup> createState() => _EditInstructionPopupState();
}

class _EditInstructionPopupState extends State<EditInstructionPopup>
    with Validators {
  final TextEditingController _qController = TextEditingController();
  final TextEditingController _uController = TextEditingController();
  bool loading = false;
  Duration _initialDuration = const Duration(hours: 0, minutes: 0);
  Duration? _duration;
  @override
  void initState() {
    super.initState();
    var recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    _qController.text = recipeProvider.instructions[widget.index].title;
    _duration = recipeProvider.instructions[widget.index].duration;
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
            SizedBox(
              // height: 300,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("Add Instruction"),
                      const Gap(20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppInputField(
                            title: "Instruction name",
                            child: TextFormField(
                              controller: _qController,
                              validator: validateName,
                              decoration: const InputDecoration(
                                hintText: "Instruction name",
                              ),
                            ),
                          ),
                          const Gap(20),
                          ListTile(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: const Icon(Icons.date_range_outlined),
                            title: Text(_duration == null
                                ? "Duration"
                                : "${_duration!.inMinutes} minutes"),
                            trailing: _duration != null
                                ? const Icon(Icons.chevron_right)
                                : const Icon(Icons.edit),
                            onTap: () async {
                              var resultingDuration = await showDurationPicker(
                                context: context,
                                initialTime:
                                    _duration ?? const Duration(minutes: 30),
                              );
                              setState(() {
                                _duration = resultingDuration;
                              });
                            },
                          )
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
                                if (!formKey.currentState!.validate()) return;
                                recipeProvider.editInstruction(
                                  Instruction(
                                    title: _qController.text,
                                    details: _uController.text,
                                    duration: _duration,
                                    order: recipeProvider
                                        .instructions[widget.index].order,
                                  ),
                                  widget.index,
                                );
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
            )
          ],
        ),
      ),
    );
  }
}
