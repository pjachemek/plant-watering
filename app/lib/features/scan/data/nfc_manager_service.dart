import 'dart:async';

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

/// [NfcService] on top of nfc_manager. On Android the session uses reader
/// mode, which stops the system from dispatching the tag to other apps while
/// we read or write (AGENTS.md section 7, write flow step 2).
class NfcManagerService implements NfcService {
  new({nm.NfcManager? manager}) : _manager = manager ?? nm.NfcManager.instance;

  final nm.NfcManager _manager;
  Completer<Result<Object?, NfcFailure>>? _pending;

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
    final result = await _session((tag) async {
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
    final result = await _session((tag) => _write(tag, link, overwrite));
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
    final readBack = classifyNdefMessage(await ndef.read());
    final verified =
        readBack is PlantLinkTag && readBack.token == TagLink.parse(link);
    return verified ? const Success(null) : const Failure(WriteNotVerified());
  }

  /// Runs one user-initiated session: waits for a tag, handles it with
  /// [onTag], then stops the session. Only one session at a time.
  Future<Result<Object?, NfcFailure>> _session(
    Future<Result<Object?, NfcFailure>> Function(nm.NfcTag tag) onTag,
  ) async {
    final availability = await this.availability();
    if (availability != NfcAvailability.available) {
      return Failure(NfcUnavailable(availability));
    }
    await cancel();
    final pending = _pending = Completer();
    try {
      await _manager.startSession(
        pollingOptions: {nm.NfcPollingOption.iso14443},
        onDiscovered: (tag) async {
          if (pending.isCompleted) return;
          Result<Object?, NfcFailure> result;
          try {
            result = await onTag(tag);
          } on Object catch (e) {
            result = Failure(failureFromPlatform(e));
          }
          await _stop();
          if (!pending.isCompleted) pending.complete(result);
        },
      );
    } on Object catch (e) {
      _pending = null;
      return Failure(failureFromPlatform(e));
    }
    return await pending.future;
  }

  @override
  Future<void> cancel() async {
    final pending = _pending;
    if (pending != null && !pending.isCompleted) {
      pending.complete(const Failure(NfcCancelled()));
    }
    await _stop();
  }

  Future<void> _stop() async {
    _pending = null;
    try {
      await _manager.stopSession();
    } on PlatformException {
      // No session running: nothing to stop.
    }
  }
}
