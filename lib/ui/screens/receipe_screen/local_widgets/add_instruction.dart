import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/models/recipe_flow/instruction.dart';
import 'package:grocipe/ui/provider/recipe_provider.dart';
import 'package:provider/provider.dart';

class InstructionPopup extends StatefulWidget {
  const InstructionPopup({Key? key}) : super(key: key);

  @override
  State<InstructionPopup> createState() => _InstructionPopupState();
}

class _InstructionPopupState extends State<InstructionPopup> with Validators {
  final TextEditingController _qController = TextEditingController();
  Duration? _duration;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var recipeProvider = Provider.of<RecipeProvider>(context, listen: true);
    var l10n = context.l10n;

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
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(l10n.addAnInstruction),
                      const Gap(20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppInputField(
                            title: l10n.instruction_name,
                            child: TextFormField(
                              controller: _qController,
                              validator: validateName,
                              decoration: InputDecoration(
                                hintText: l10n.hint_instruction_name,
                              ),
                            ),
                          ),
                          const Gap(20),
                          ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: _duration == null
                                    ? context.colors.greyOutline
                                    : context.primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: const Icon(Icons.date_range_outlined),
                            title: Text(_duration == null
                                ? l10n.duration
                                : "${_duration!.inMinutes} ${l10n.minutes}"),
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
                          //   child: CustomTextButton(
                          //     text: l10n.cancel,
                          //     onPressed: () {
                          //       Navigator.pop(context);
                          //     },
                          //   ),
                          // ),
                          Expanded(
                            child: AppElevatedButton(
                              notifier: ValueNotifier(false),
                              onPressed: () {
                                if (!formKey.currentState!.validate()) return;
                                recipeProvider.addInstruction(
                                  Instruction(
                                    title: _qController.text,
                                    duration: _duration,
                                    details: "",
                                    order: recipeProvider.instructions.length,
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              style:
                                  context.elevatedButtonTheme.style?.copyWith(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  context.primaryColor,
                                ),
                              ),
                              child: const Text("Add"),
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
