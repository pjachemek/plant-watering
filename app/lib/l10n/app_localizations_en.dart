// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Plant NFC';

  @override
  String get plantsTitle => 'Plants';

  @override
  String get plantsEmptyTitle => 'No plants yet';

  @override
  String get plantsEmptyBody =>
      'Add your first plant, then stick an NFC tag on its pot. Tap the tag with your phone to see how and when to water it.';

  @override
  String get plantsEmptyIllustrationLabel => 'Potted plant illustration';

  @override
  String get addPlantAction => 'Add plant';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get tagOpeningTitle => 'Plant tag';

  @override
  String get tagOpeningBody =>
      'This tag link opened the app. Plant cards arrive in a later build.';

  @override
  String get backToPlantsAction => 'Go to plants';

  @override
  String get notFoundTitle => 'Page not found';
}
