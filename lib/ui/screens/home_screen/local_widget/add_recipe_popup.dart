import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/settings/palette.dart';

class AddRecipePopup extends StatefulWidget {
  const AddRecipePopup({super.key});

  @override
  State<AddRecipePopup> createState() => _AddRecipePopupState();
}

class _AddRecipePopupState extends State<AddRecipePopup> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(10),
      // height: 60,
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        // shape: BoxShape.circle,
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
            onTap: () {
              context.pop();

              context.go('/main_screen/add/url');
            },
            leading: Icon(CupertinoIcons.add_circled,
                color: Theme.of(context).colorScheme.secondary),
            title: Text(
              l10n.importUsingUrl,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              context.pop();

              context.go('/main_screen/add/recipe');
            },
            leading: Image.asset('assets/images/icons/manually.png'),
            title: Text(
              l10n.addManually,
            ),
          ),
        ],
      ),
    );
  }
}
