import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grocipe/helper/utils/validators.dart';

class PasswordField extends HookWidget with Validators {
  final ValueChanged<String>? onChanged;

  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final String? hintText, label;
  final VoidCallback? onEditingComplete;
  final bool autofocus;
  final Color? fillColor;

  const PasswordField({
    super.key,
    this.label,
    this.onChanged,
    this.controller,
    this.autofocus = false,
    this.hintText,
    this.onEditingComplete,
    this.textInputAction = TextInputAction.done,
    this.validator,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final showPassword = useState(false);
    void toggleShowPassword() => showPassword.value = !showPassword.value;
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      obscureText: !showPassword.value,
      onChanged: onChanged,
      validator: validator ?? validatePassword,
      autofillHints: const [AutofillHints.password],
      inputFormatters: [FilteringTextInputFormatter.deny(' ')],
      textInputAction: textInputAction,
      keyboardType: TextInputType.text,
      obscuringCharacter: '*',
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          fillColor: fillColor,
          hintText: hintText ?? "* * * * * * * *",
          label: label == null ? null : Text("$label"),
          suffixIconConstraints: BoxConstraints(maxHeight: 30),
          suffixIcon: GestureDetector(
            onTap: () {
              toggleShowPassword();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(
                showPassword.value ? "Hide" : "Show",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          )),
    );
  }
}
