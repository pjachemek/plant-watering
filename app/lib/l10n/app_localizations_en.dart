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

  @override
  String get updateRequiredTitle => 'Update Plant NFC';

  @override
  String get updateRequiredBody =>
      'This version is no longer supported. Update the app to keep using it. Everything saved on this phone is kept and syncs after the update.';

  @override
  String get openStoreAction => 'Open Google Play';

  @override
  String get storeOpenFailed =>
      'Couldn\'t open Google Play. Update Plant NFC from the Play Store app.';

  @override
  String get updateAvailableMessage =>
      'A new version of Plant NFC is available.';

  @override
  String get updateAction => 'Update';

  @override
  String get dismissAction => 'Dismiss';

  @override
  String get householdSetupTitle => 'Set up your household';

  @override
  String get householdSetupBody =>
      'Create a household for your plants, or join one with an invite code from someone in it.';

  @override
  String get householdCreateAction => 'Create a household';

  @override
  String get householdJoinAction => 'Join with a code';

  @override
  String get householdCreateTitle => 'Create a household';

  @override
  String get householdNameLabel => 'Household name';

  @override
  String get householdNameHint => 'For example, Our home';

  @override
  String get householdYourNameLabel => 'Your name';

  @override
  String get householdYourNameHelper => 'Shown to the people in your household';

  @override
  String get householdNameRequired => 'Enter a name (up to 80 characters)';

  @override
  String get householdYourNameRequired =>
      'Enter your name (up to 60 characters)';

  @override
  String get householdCreateSubmit => 'Create';

  @override
  String get householdJoinTitle => 'Join a household';

  @override
  String get householdCodeLabel => 'Invite code';

  @override
  String get householdCodeHelper =>
      '12 letters and numbers, or the whole invite link';

  @override
  String get householdCodeInvalidFormat =>
      'Enter the 12-character code or the invite link';

  @override
  String get householdJoinSubmit => 'Join';

  @override
  String get householdTitle => 'Household';

  @override
  String get householdMembersHeading => 'Members';

  @override
  String get householdInviteAction => 'Invite someone';

  @override
  String get householdInviteTitle => 'Invite someone';

  @override
  String householdInviteBody(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Share this code or link with someone in your home. It works once and expires on $dateString.';
  }

  @override
  String householdInviteCodeLabel(String code) {
    return 'Invite code $code';
  }

  @override
  String get householdCopyLinkAction => 'Copy link';

  @override
  String get householdLinkCopied => 'Invite link copied';

  @override
  String get householdLeaveAction => 'Leave household';

  @override
  String householdLeaveTitle(String name) {
    return 'Leave $name?';
  }

  @override
  String get householdLeaveBody =>
      'You will no longer see its plants on this phone. Someone in it can invite you again.';

  @override
  String get householdLeaveConfirm => 'Leave';

  @override
  String get householdLastMemberTitle => 'You are the last member';

  @override
  String get householdLastMemberBody =>
      'Leaving deletes the household, with all its plants and waterings, for everyone. This can\'t be undone.';

  @override
  String get householdDeleteConfirm => 'Delete household';

  @override
  String get householdErrorNetwork =>
      'Can\'t reach the server. Check your connection and try again.';

  @override
  String get householdErrorInvalidCode =>
      'This invite code isn\'t valid. It may have expired or been used already. Ask for a new one.';

  @override
  String get householdErrorUnknown => 'Something went wrong. Try again.';

  @override
  String get signOutPendingTitle => 'Sign out with unsent changes?';

  @override
  String signOutPendingBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count changes made on this phone haven\'t reached the server yet. If you sign out now, they will be lost.',
      one: '1 change made on this phone hasn\'t reached the server yet. If you sign out now, it will be lost.',
    );
    return '$_temp0';
  }

  @override
  String get signOutAnywayAction => 'Sign out anyway';

  @override
  String get syncTestTitle => 'Sync test';

  @override
  String get syncTestOpenAction => 'Sync test';

  @override
  String syncTestStatus(String sync, String live, int queued) {
    return 'Sync: $sync · Live: $live · Waiting to send: $queued';
  }

  @override
  String get syncTestNoHousehold => 'Create or join a household first.';

  @override
  String get syncTestAddPlant => 'Add test plant';

  @override
  String get syncTestNeverWatered => 'Never watered';

  @override
  String syncTestLastWatered(DateTime time, String name) {
    final intl.DateFormat timeDateFormat = intl.DateFormat.Hms(localeName);
    final String timeString = timeDateFormat.format(time);

    return 'Last watered $timeString by $name';
  }

  @override
  String get syncTestWater => 'Water';

  @override
  String get syncTestUndo => 'Undo';

  @override
  String get syncTestSomeone => 'someone';

  @override
  String get presetSearchTitle => 'Preset search';

  @override
  String get presetSearchOpenAction => 'Preset search';

  @override
  String get presetSearchLabel => 'Search plants';

  @override
  String get presetSearchHint => 'Name, Latin name or Polish name';

  @override
  String presetSearchTiming(int count, String ms) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
    );
    return '$_temp0 in $ms ms';
  }

  @override
  String get presetSearchNoResults => 'No presets match';

  @override
  String presetSearchMatched(String name) {
    return 'Matched: $name';
  }

  @override
  String presetSearchCare(int summer, int winter, String method) {
    return 'Every $summer days in summer, $winter in winter · $method';
  }
}
