import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ndef_record/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart' as nm;
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/scan/data/ndef_uri_codec.dart';
import 'package:plantnfc/features/scan/domain/nfc_service.dart';
import 'package:plantnfc/features/scan/domain/tag_link.dart';

/// Classifies an NDEF message into what the app cares about.
TagContent classifyNdefMessage(NdefMessage? message) {
  final records = message?.records ?? const <NdefRecord>[];
  final meaningful = records
      .where((r) => r.typeNameFormat != TypeNameFormat.empty)
      .toList();
  if (meaningful.isEmpty) return const EmptyTag();
  if (meaningful.length == 1) {
    final uri = NdefUriCodec.decode(meaningful.single);
    final token = uri == null ? null : TagLink.parseString(uri);
    if (token != null) return PlantLinkTag(token);
  }
  return const ForeignDataTag();
}

/// Reads the tag back until it holds [link], at most [attempts] times.
///
/// A shaky hand can leave the phone at the edge of range: the write completes,
/// but the first read-back sees a partial or empty sticker. One re-read avoids
/// reporting a false failure (ADR-0010). Platform errors from [read], such as
/// a lost tag, propagate to the caller.
Future<bool> verifyWrittenLink(
  Future<NdefMessage?> Function() read,
  Uri link, {
  int attempts = 2,
}) async {
  final expected = TagLink.parse(link);
  for (var i = 0; i < attempts; i++) {
    final content = classifyNdefMessage(await read());
    if (content is PlantLinkTag && content.token == expected) return true;
  }
  return false;
}

/// Maps a platform error to a typed failure. On Android, nfc_manager reports
/// Java exceptions by class name (`TagLostException`, `IOException`, ...).
NfcFailure failureFromPlatform(Object error) {
  if (error is PlatformException) {
    return switch (error.code) {
      'TagLostException' || 'IOException' => const TagLost(),
      'not_supported' => const NfcUnavailable(NfcAvailability.unsupported),
      'tag_not_found' => const TagNotNdef(),
      final code => NfcUnknownFailure(code),
    };
  }
  return NfcUnknownFailure(error.runtimeType.toString());
}

/// Switches the app's own tag-link filter in `MainActivity` on or off.
/// Android drops that filter whenever reader mode ends, so it is switched off
/// while a session is open and handed back when the session closes
/// (ADR-0010).
typedef SetTagDispatch = Future<void> Function({required bool enabled});

const MethodChannel _tagDispatchChannel = MethodChannel(
  'pl.pampait.plantnfc/tag_dispatch',
);

/// The real [SetTagDispatch]. A no-op where the channel doesn't exist
/// (tests, and iOS until it gets an equivalent).
Future<void> platformSetTagDispatch({required bool enabled}) async {
  try {
    await _tagDispatchChannel.invokeMethod<void>('setEnabled', enabled);
  } on MissingPluginException {
    // No native side: nothing to switch.
  }
}

/// [NfcService] on top of nfc_manager. On Android the session uses reader
/// mode, which stops the system from dispatching the tag to other apps while
/// we read or write (AGENTS.md section 7, write flow step 2).
///
/// The session stays open between operations until [cancel], and tags seen
/// while no operation is pending are ignored. Otherwise a phone still resting
/// on the sticker after a write would be re-detected by Android, which would
/// open the tag link or show its web-link prompt (ADR-0010, device findings).
class NfcManagerService implements NfcService {
  new({nm.NfcManager? manager, SetTagDispatch? setTagDispatch})
    : _manager = manager ?? nm.NfcManager.instance,
      _setTagDispatch = setTagDispatch ?? platformSetTagDispatch;

  final nm.NfcManager _manager;
  final SetTagDispatch _setTagDispatch;

  bool _sessionOpen = false;
  Completer<Result<Object?, NfcFailure>>? _pending;
  Future<Result<Object?, NfcFailure>> Function(nm.NfcTag tag)? _onTag;

  @override
  Future<NfcAvailability> availability() async {
    try {
      return switch (await _manager.checkAvailability()) {
        nm.NfcAvailability.enabled => NfcAvailability.available,
        nm.NfcAvailability.disabled => NfcAvailability.disabled,
        nm.NfcAvailability.unsupported => NfcAvailability.unsupported,
      };
    } on PlatformException {
      return NfcAvailability.unsupported;
    }
  }

  @override
  Future<Result<TagContent, NfcFailure>> readTag() async {
    final result = await _run((tag) async {
      final ndef = Ndef.from(tag);
      if (ndef == null) return const Failure(TagNotNdef());
      return Success(classifyNdefMessage(await ndef.read()));
    });
    return switch (result) {
      Success(:final value) => Success(value! as TagContent),
      Failure(:final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<void, NfcFailure>> writeLink(
    Uri link, {
    bool overwrite = false,
  }) async {
    final result = await _run((tag) => _write(tag, link, overwrite));
    return switch (result) {
      Success() => const Success(null),
      Failure(:final failure) => Failure(failure),
    };
  }

  Future<Result<Object?, NfcFailure>> _write(
    nm.NfcTag tag,
    Uri link,
    bool overwrite,
  ) async {
    final message = NdefUriCodec.messageFor(link);
    final ndef = Ndef.from(tag);
    if (ndef == null) return const Failure(TagNotNdef());

    final existing = classifyNdefMessage(ndef.cachedMessage);
    final alreadyThisLink =
        existing is PlantLinkTag && existing.token == TagLink.parse(link);
    if (!overwrite && existing is! EmptyTag && !alreadyThisLink) {
      return Failure(OverwriteNeedsConfirmation(existing));
    }
    if (!ndef.isWritable) return const Failure(TagReadOnly());
    if (message.byteLength > ndef.maxSize) {
      return Failure(
        TagTooSmall(
          neededBytes: message.byteLength,
          capacityBytes: ndef.maxSize,
        ),
      );
    }

    await ndef.write(message: message);
    final verified = await verifyWrittenLink(ndef.read, link);
    return verified ? const Success(null) : const Failure(WriteNotVerified());
  }

  /// Runs one operation: waits for the next tag and handles it with [onTag].
  /// Opens the session if needed; a pending operation is cancelled first.
  Future<Result<Object?, NfcFailure>> _run(
    Future<Result<Object?, NfcFailure>> Function(nm.NfcTag tag) onTag,
  ) async {
    final availability = await this.availability();
    if (availability != NfcAvailability.available) {
      return Failure(NfcUnavailable(availability));
    }
    _completePending(const Failure(NfcCancelled()));
    final pending = _pending = Completer();
    _onTag = onTag;
    if (!_sessionOpen) {
      try {
        await _setTagDispatch(enabled: false);
        await _manager.startSession(
          pollingOptions: {nm.NfcPollingOption.iso14443},
          onDiscovered: _onDiscovered,
        );
        _sessionOpen = true;
      } on Object catch (e) {
        _pending = null;
        _onTag = null;
        await _setTagDispatch(enabled: true);
        return Failure(failureFromPlatform(e));
      }
    }
    return await pending.future;
  }

  Future<void> _onDiscovered(nm.NfcTag tag) async {
    final pending = _pending;
    final onTag = _onTag;
    // No operation waiting: reader mode has already kept the tag away from
    // Android, so ignoring it here is enough.
    if (pending == null || pending.isCompleted || onTag == null) return;
    _onTag = null;
    Result<Object?, NfcFailure> result;
    try {
      result = await onTag(tag);
    } on Object catch (e) {
      result = Failure(failureFromPlatform(e));
    }
    _logFailure(result);
    if (!pending.isCompleted) pending.complete(result);
  }

  /// Cancels a pending operation and closes the session. Call it when the
  /// screen that uses NFC closes.
  @override
  Future<void> cancel() async {
    _completePending(const Failure(NfcCancelled()));
    if (!_sessionOpen) return;
    _sessionOpen = false;
    try {
      await _manager.stopSession();
    } on PlatformException {
      // Already stopped: nothing to do.
    }
    await _setTagDispatch(enabled: true);
  }

  void _completePending(Result<Object?, NfcFailure> result) {
    final pending = _pending;
    _pending = null;
    _onTag = null;
    if (pending != null && !pending.isCompleted) pending.complete(result);
  }

  /// Debug builds only: names the failure so device tests can be traced in
  /// logcat. Never logs tag contents or tokens.
  static void _logFailure(Result<Object?, NfcFailure> result) {
    if (!kDebugMode || result is! Failure<Object?, NfcFailure>) return;
    final failure = result.failure;
    final detail = failure is NfcUnknownFailure ? ' (${failure.code})' : '';
    debugPrint('nfc_failure: ${failure.runtimeType}$detail');
  }
}
