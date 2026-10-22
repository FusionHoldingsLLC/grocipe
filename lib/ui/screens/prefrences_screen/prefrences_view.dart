import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/ui/provider/main_provider.dart';
import 'package:provider/provider.dart' as provider;

class PrefrencesScreen extends StatefulWidget {
  const PrefrencesScreen({super.key});

  @override
  State<PrefrencesScreen> createState() => _PrefrencesScreenState();
}

class _PrefrencesScreenState extends State<PrefrencesScreen> {
  String? option = "English";
  List<String> options = ["English", "France", "Spanish"];
  Map<String, String> lang = {
    "English": "en",
    "France": "fr",
    "Spanish": "es",
  };
  Map<String, String> langreverted = {
    "en": "English",
    "fr": "France",
    "es": "Spanish",
  };

  @override
  void initState() {
    super.initState();
    var mainProvider =
        provider.Provider.of<MainProvider>(context, listen: false);
    option = langreverted[mainProvider.preferredLanguage];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    var mainProvider =
        provider.Provider.of<MainProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: const AppBackButton(),
        title: Text(l10n.preferences_screen_title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.preferred_language,
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
                hint: Text(l10n.select_language),
                value: option,
                isExpanded: true,
                onChanged: (newValue) {
                  setState(() {
                    option = newValue;
                  });
                },
                items: options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 150,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: AppElevatedButton(
            notifier: ValueNotifier(false),
            onPressed: () {
              mainProvider.updateLanguage(lang[option]!);
              Navigator.pop(context);
            },
            child: Text(l10n.apply_changes),
          ),
        ),
      ),
    );
  }
}
