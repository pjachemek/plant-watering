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

  @override
  String get nfcSpikeTitle => 'NFC test';

  @override
  String get nfcSpikeOpenAction => 'NFC test';

  @override
  String get nfcSpikeIntro =>
      'Write a test link to a sticker, or read what a sticker holds. Test links open the plant tag screen.';

  @override
  String get nfcWriteAction => 'Write test sticker';

  @override
  String get nfcReadAction => 'Read sticker';

  @override
  String get nfcHoldNearTitle => 'Hold your phone near the sticker';

  @override
  String get nfcHoldNearBody => 'Keep it still until you feel a vibration.';

  @override
  String get nfcStickerIllustrationLabel => 'NFC sticker';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get retryAction => 'Try again';

  @override
  String get nfcWriteSuccess => 'Sticker written and checked';

  @override
  String get nfcReadPlantLink => 'This sticker holds a plant link';

  @override
  String get nfcReadEmpty => 'This sticker is empty';

  @override
  String get nfcReadForeign => 'This sticker holds data from another app';

  @override
  String get nfcOpenTagAction => 'Open plant link';

  @override
  String get nfcOverwritePlantTitle => 'This sticker already has a plant link';

  @override
  String get nfcOverwriteForeignTitle =>
      'This sticker already holds other data';

  @override
  String get nfcOverwriteBody =>
      'Writing replaces what is on it. Hold your phone near the sticker again to continue.';

  @override
  String get nfcOverwriteAction => 'Overwrite sticker';

  @override
  String get nfcErrorDisabled =>
      'NFC is turned off. Turn it on in your phone settings, then try again.';

  @override
  String get nfcErrorUnsupported =>
      'This phone can’t read NFC stickers. You can use QR codes instead.';

  @override
  String get nfcErrorNotNdef =>
      'This sticker type isn’t supported. Use an NTAG213 or NTAG215 sticker.';

  @override
  String get nfcErrorReadOnly => 'This sticker is locked and can’t be written.';

  @override
  String get nfcErrorTooSmall =>
      'This sticker is too small for the link. Use an NTAG213 or larger sticker.';

  @override
  String get nfcErrorTagLost =>
      'The phone moved away too soon. Hold it still on the sticker and try again.';

  @override
  String get nfcErrorNotVerified =>
      'The sticker didn’t save the link. Hold your phone still on the sticker and try again.';

  @override
  String get nfcErrorUnknown =>
      'Something went wrong with the sticker. Try again.';

  @override
  String get signInTitle => 'Sign in to Plant NFC';

  @override
  String get signInBody =>
      'Everyone in your household sees the same plants and waterings.';

  @override
  String get signInIllustrationLabel => 'Plant NFC';

  @override
  String get signInGoogleAction => 'Continue with Google';

  @override
  String get authErrorNetwork =>
      'Can\'t reach the server. Check your connection and try again.';

  @override
  String get authErrorRateLimited =>
      'Too many attempts. Wait a minute, then try again.';

  @override
  String get authErrorNotConfigured => 'Sign-in isn\'t set up in this build.';

  @override
  String get authErrorUnknown => 'Sign-in didn\'t work. Try again.';

  @override
  String get signOutAction => 'Sign out';
}
