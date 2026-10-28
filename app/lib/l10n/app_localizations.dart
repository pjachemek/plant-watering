import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// App name shown in the task switcher and app bar.
  ///
  /// In en, this message translates to:
  /// **'Plant NFC'**
  String get appTitle;

  /// Title of the home screen that lists the household's plants.
  ///
  /// In en, this message translates to:
  /// **'Plants'**
  String get plantsTitle;

  /// Heading of the empty state on the home screen.
  ///
  /// In en, this message translates to:
  /// **'No plants yet'**
  String get plantsEmptyTitle;

  /// Explanation in the empty state on the home screen.
  ///
  /// In en, this message translates to:
  /// **'Add your first plant, then stick an NFC tag on its pot. Tap the tag with your phone to see how and when to water it.'**
  String get plantsEmptyBody;

  /// Screen reader label for the empty-state illustration.
  ///
  /// In en, this message translates to:
  /// **'Potted plant illustration'**
  String get plantsEmptyIllustrationLabel;

  /// Button that starts the add-plant flow.
  ///
  /// In en, this message translates to:
  /// **'Add plant'**
  String get addPlantAction;

  /// Short message shown for features not built yet in this preview build.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// Title of the screen opened by scanning a plant tag.
  ///
  /// In en, this message translates to:
  /// **'Plant tag'**
  String get tagOpeningTitle;

  /// Placeholder text on the tag screen until plant cards are built.
  ///
  /// In en, this message translates to:
  /// **'This tag link opened the app. Plant cards arrive in a later build.'**
  String get tagOpeningBody;

  /// Button that leaves the tag screen and opens the plant list.
  ///
  /// In en, this message translates to:
  /// **'Go to plants'**
  String get backToPlantsAction;

  /// Title shown when a link points to a screen that doesn't exist.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get notFoundTitle;

  /// Title of the developer screen for testing NFC sticker writing and reading.
  ///
  /// In en, this message translates to:
  /// **'NFC test'**
  String get nfcSpikeTitle;

  /// Developer menu button that opens the NFC test screen. Debug builds only.
  ///
  /// In en, this message translates to:
  /// **'NFC test'**
  String get nfcSpikeOpenAction;

  /// Explanation at the top of the NFC test screen.
  ///
  /// In en, this message translates to:
  /// **'Write a test link to a sticker, or read what a sticker holds. Test links open the plant tag screen.'**
  String get nfcSpikeIntro;

  /// Button that writes a new test link to an NFC sticker.
  ///
  /// In en, this message translates to:
  /// **'Write test sticker'**
  String get nfcWriteAction;

  /// Button that reads an NFC sticker.
  ///
  /// In en, this message translates to:
  /// **'Read sticker'**
  String get nfcReadAction;

  /// Shown while the app waits for an NFC sticker.
  ///
  /// In en, this message translates to:
  /// **'Hold your phone near the sticker'**
  String get nfcHoldNearTitle;

  /// Hint shown while waiting for an NFC sticker.
  ///
  /// In en, this message translates to:
  /// **'Keep it still until you feel a vibration.'**
  String get nfcHoldNearBody;

  /// Screen reader label for the NFC sticker illustration.
  ///
  /// In en, this message translates to:
  /// **'NFC sticker'**
  String get nfcStickerIllustrationLabel;

  /// Generic cancel button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// Generic retry button.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retryAction;

  /// Shown after a link was written to a sticker and read back correctly.
  ///
  /// In en, this message translates to:
  /// **'Sticker written and checked'**
  String get nfcWriteSuccess;

  /// Result of reading a sticker that holds one of our links.
  ///
  /// In en, this message translates to:
  /// **'This sticker holds a plant link'**
  String get nfcReadPlantLink;

  /// Result of reading a sticker with no data.
  ///
  /// In en, this message translates to:
  /// **'This sticker is empty'**
  String get nfcReadEmpty;

  /// Result of reading a sticker that holds something other than our link.
  ///
  /// In en, this message translates to:
  /// **'This sticker holds data from another app'**
  String get nfcReadForeign;

  /// Button that opens the plant tag screen for the link that was just read.
  ///
  /// In en, this message translates to:
  /// **'Open plant link'**
  String get nfcOpenTagAction;

  /// Title asking to confirm overwriting a sticker that holds another plant link.
  ///
  /// In en, this message translates to:
  /// **'This sticker already has a plant link'**
  String get nfcOverwritePlantTitle;

  /// Title asking to confirm overwriting a sticker with foreign data.
  ///
  /// In en, this message translates to:
  /// **'This sticker already holds other data'**
  String get nfcOverwriteForeignTitle;

  /// Explanation in the overwrite confirmation.
  ///
  /// In en, this message translates to:
  /// **'Writing replaces what is on it. Hold your phone near the sticker again to continue.'**
  String get nfcOverwriteBody;

  /// Button that confirms overwriting a sticker.
  ///
  /// In en, this message translates to:
  /// **'Overwrite sticker'**
  String get nfcOverwriteAction;

  /// Error when NFC is disabled.
  ///
  /// In en, this message translates to:
  /// **'NFC is turned off. Turn it on in your phone settings, then try again.'**
  String get nfcErrorDisabled;

  /// Error when the phone has no NFC.
  ///
  /// In en, this message translates to:
  /// **'This phone can’t read NFC stickers. You can use QR codes instead.'**
  String get nfcErrorUnsupported;

  /// Error when the tag cannot hold NDEF data.
  ///
  /// In en, this message translates to:
  /// **'This sticker type isn’t supported. Use an NTAG213 or NTAG215 sticker.'**
  String get nfcErrorNotNdef;

  /// Error when the tag is read-only.
  ///
  /// In en, this message translates to:
  /// **'This sticker is locked and can’t be written.'**
  String get nfcErrorReadOnly;

  /// Error when the link does not fit on the tag.
  ///
  /// In en, this message translates to:
  /// **'This sticker is too small for the link. Use an NTAG213 or larger sticker.'**
  String get nfcErrorTooSmall;

  /// Error when the tag connection was lost.
  ///
  /// In en, this message translates to:
  /// **'The phone moved away too soon. Hold it still on the sticker and try again.'**
  String get nfcErrorTagLost;

  /// Error when read-back verification failed.
  ///
  /// In en, this message translates to:
  /// **'The sticker didn’t save the link. Hold your phone still on the sticker and try again.'**
  String get nfcErrorNotVerified;

  /// Generic NFC error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong with the sticker. Try again.'**
  String get nfcErrorUnknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
