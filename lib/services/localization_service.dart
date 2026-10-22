import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class LocalizationService {
  AppLocalizations getL10n(BuildContext context) {
    return AppLocalizations.of(context);
  }
}
