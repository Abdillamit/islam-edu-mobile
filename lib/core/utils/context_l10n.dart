import 'package:flutter/widgets.dart';
import 'package:islam_edu_mobile/l10n/app_localizations.dart';

extension ContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
