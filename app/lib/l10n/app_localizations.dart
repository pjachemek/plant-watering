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

  /// Heading of the sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Sign in to Plant NFC'**
  String get signInTitle;

  /// Explanation under the sign-in heading.
  ///
  /// In en, this message translates to:
  /// **'Everyone in your household sees the same plants and waterings.'**
  String get signInBody;

  /// Screen reader label for the sign-in illustration.
  ///
  /// In en, this message translates to:
  /// **'Plant NFC'**
  String get signInIllustrationLabel;

  /// Button that signs in with a Google account.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get signInGoogleAction;

  /// Sign-in error: no connection.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the server. Check your connection and try again.'**
  String get authErrorNetwork;

  /// Sign-in error: too many attempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a minute, then try again.'**
  String get authErrorRateLimited;

  /// Sign-in error: the app build is missing configuration.
  ///
  /// In en, this message translates to:
  /// **'Sign-in isn\'t set up in this build.'**
  String get authErrorNotConfigured;

  /// Generic sign-in error.
  ///
  /// In en, this message translates to:
  /// **'Sign-in didn\'t work. Try again.'**
  String get authErrorUnknown;

  /// Button that signs out on this phone.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOutAction;

  /// Heading of the blocking screen shown when this app version is no longer supported.
  ///
  /// In en, this message translates to:
  /// **'Update Plant NFC'**
  String get updateRequiredTitle;

  /// Explanation on the blocking update screen.
  ///
  /// In en, this message translates to:
  /// **'This version is no longer supported. Update the app to keep using it. Everything saved on this phone is kept and syncs after the update.'**
  String get updateRequiredBody;

  /// Button that opens the app's store listing.
  ///
  /// In en, this message translates to:
  /// **'Open Google Play'**
  String get openStoreAction;

  /// Shown when the store listing can't be opened.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open Google Play. Update Plant NFC from the Play Store app.'**
  String get storeOpenFailed;

  /// Dismissible prompt shown when a newer app version is recommended.
  ///
  /// In en, this message translates to:
  /// **'A new version of Plant NFC is available.'**
  String get updateAvailableMessage;

  /// Button in the update prompt that opens the store listing.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateAction;

  /// Button that closes a prompt.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismissAction;

  /// Heading on the home screen before the person has a household.
  ///
  /// In en, this message translates to:
  /// **'Set up your household'**
  String get householdSetupTitle;

  /// Explanation before the person has a household.
  ///
  /// In en, this message translates to:
  /// **'Create a household for your plants, or join one with an invite code from someone in it.'**
  String get householdSetupBody;

  /// Button that opens the create-household form.
  ///
  /// In en, this message translates to:
  /// **'Create a household'**
  String get householdCreateAction;

  /// Button that opens the join-household form.
  ///
  /// In en, this message translates to:
  /// **'Join with a code'**
  String get householdJoinAction;

  /// Title of the create-household screen.
  ///
  /// In en, this message translates to:
  /// **'Create a household'**
  String get householdCreateTitle;

  /// Label of the household name field.
  ///
  /// In en, this message translates to:
  /// **'Household name'**
  String get householdNameLabel;

  /// Hint in the household name field.
  ///
  /// In en, this message translates to:
  /// **'For example, Our home'**
  String get householdNameHint;

  /// Label of the field for the person's display name.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get householdYourNameLabel;

  /// Helper text under the display name field.
  ///
  /// In en, this message translates to:
  /// **'Shown to the people in your household'**
  String get householdYourNameHelper;

  /// Validation message for the household name.
  ///
  /// In en, this message translates to:
  /// **'Enter a name (up to 80 characters)'**
  String get householdNameRequired;

  /// Validation message for the display name.
  ///
  /// In en, this message translates to:
  /// **'Enter your name (up to 60 characters)'**
  String get householdYourNameRequired;

  /// Button that creates the household.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get householdCreateSubmit;

  /// Title of the join-household screen.
  ///
  /// In en, this message translates to:
  /// **'Join a household'**
  String get householdJoinTitle;

  /// Label of the invite code field.
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get householdCodeLabel;

  /// Helper text under the invite code field.
  ///
  /// In en, this message translates to:
  /// **'12 letters and numbers, or the whole invite link'**
  String get householdCodeHelper;

  /// Validation message for a malformed invite code.
  ///
  /// In en, this message translates to:
  /// **'Enter the 12-character code or the invite link'**
  String get householdCodeInvalidFormat;

  /// Button that joins the household.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get householdJoinSubmit;

  /// Title of the household screen and tooltip of the button that opens it.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get householdTitle;

  /// Heading of the member list.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get householdMembersHeading;

  /// Button that creates an invite code.
  ///
  /// In en, this message translates to:
  /// **'Invite someone'**
  String get householdInviteAction;

  /// Heading of the invite sheet.
  ///
  /// In en, this message translates to:
  /// **'Invite someone'**
  String get householdInviteTitle;

  /// Explanation on the invite sheet.
  ///
  /// In en, this message translates to:
  /// **'Share this code or link with someone in your home. It works once and expires on {date}.'**
  String householdInviteBody(DateTime date);

  /// Screen reader label for the invite code, read character by character by the screen reader.
  ///
  /// In en, this message translates to:
  /// **'Invite code {code}'**
  String householdInviteCodeLabel(String code);

  /// Button that copies the invite link.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get householdCopyLinkAction;

  /// Shown after the invite link was copied.
  ///
  /// In en, this message translates to:
  /// **'Invite link copied'**
  String get householdLinkCopied;

  /// Button that starts leaving the household.
  ///
  /// In en, this message translates to:
  /// **'Leave household'**
  String get householdLeaveAction;

  /// Title of the leave confirmation.
  ///
  /// In en, this message translates to:
  /// **'Leave {name}?'**
  String householdLeaveTitle(String name);

  /// Body of the leave confirmation.
  ///
  /// In en, this message translates to:
  /// **'You will no longer see its plants on this phone. Someone in it can invite you again.'**
  String get householdLeaveBody;

  /// Button that confirms leaving.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get householdLeaveConfirm;

  /// Title shown when the last member leaves.
  ///
  /// In en, this message translates to:
  /// **'You are the last member'**
  String get householdLastMemberTitle;

  /// Body of the last-member confirmation.
  ///
  /// In en, this message translates to:
  /// **'Leaving deletes the household, with all its plants and waterings, for everyone. This can\'t be undone.'**
  String get householdLastMemberBody;

  /// Button that confirms deleting the household.
  ///
  /// In en, this message translates to:
  /// **'Delete household'**
  String get householdDeleteConfirm;

  /// Household error: no connection.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the server. Check your connection and try again.'**
  String get householdErrorNetwork;

  /// Household error: the invite code can't be used.
  ///
  /// In en, this message translates to:
  /// **'This invite code isn\'t valid. It may have expired or been used already. Ask for a new one.'**
  String get householdErrorInvalidCode;

  /// Generic household error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get householdErrorUnknown;

  /// Title when signing out while changes haven't reached the server.
  ///
  /// In en, this message translates to:
  /// **'Sign out with unsent changes?'**
  String get signOutPendingTitle;

  /// Warning before signing out with unsent changes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 change made on this phone hasn\'t reached the server yet. If you sign out now, it will be lost.} other{{count} changes made on this phone haven\'t reached the server yet. If you sign out now, they will be lost.}}'**
  String signOutPendingBody(int count);

  /// Button that signs out despite unsent changes.
  ///
  /// In en, this message translates to:
  /// **'Sign out anyway'**
  String get signOutAnywayAction;

  /// Title of the developer screen for testing sync between phones. Debug builds only.
  ///
  /// In en, this message translates to:
  /// **'Sync test'**
  String get syncTestTitle;

  /// Developer menu button that opens the sync test screen. Debug builds only.
  ///
  /// In en, this message translates to:
  /// **'Sync test'**
  String get syncTestOpenAction;

  /// Status line on the sync test screen.
  ///
  /// In en, this message translates to:
  /// **'Sync: {sync} · Live: {live} · Waiting to send: {queued}'**
  String syncTestStatus(String sync, String live, int queued);

  /// Shown on the sync test screen without a household.
  ///
  /// In en, this message translates to:
  /// **'Create or join a household first.'**
  String get syncTestNoHousehold;

  /// Button that adds a test plant.
  ///
  /// In en, this message translates to:
  /// **'Add test plant'**
  String get syncTestAddPlant;

  /// Shown for a plant without waterings.
  ///
  /// In en, this message translates to:
  /// **'Never watered'**
  String get syncTestNeverWatered;

  /// Last watering of a plant on the sync test screen.
  ///
  /// In en, this message translates to:
  /// **'Last watered {time} by {name}'**
  String syncTestLastWatered(DateTime time, String name);

  /// Button that logs a watering.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get syncTestWater;

  /// Button that undoes the last watering.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get syncTestUndo;

  /// Name used when the person who watered isn't known on this phone.
  ///
  /// In en, this message translates to:
  /// **'someone'**
  String get syncTestSomeone;
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
