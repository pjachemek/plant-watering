import 'dart:async';

import 'package:meta/meta.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/scan/data/nfc_providers.dart';
import 'package:plantnfc/features/scan/domain/nfc_service.dart';
import 'package:plantnfc/features/scan/domain/tag_link.dart';
import 'package:plantnfc/features/scan/domain/tag_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nfc_spike_controller.g.dart';

enum NfcAction { read, write }

@immutable
sealed class NfcSpikeState {
  const new();
}

final class NfcSpikeIdle extends NfcSpikeState {
  const new();
}

/// A session is open; the user should hold the phone to a sticker.
final class NfcSpikeWaiting extends NfcSpikeState {
  const new(this.action);

  final NfcAction action;
}

final class NfcSpikeWritten extends NfcSpikeState {
  const new(this.token);

  final TagToken token;
}

final class NfcSpikeRead extends NfcSpikeState {
  const new(this.content);

  final TagContent content;
}

/// The sticker holds data; ask before overwriting it with [token]'s link.
final class NfcSpikeConfirmOverwrite extends NfcSpikeState {
  const new({required this.existing, required this.token});

  final TagContent existing;
  final TagToken token;
}

final class NfcSpikeFailed extends NfcSpikeState {
  const new(this.failure, this.action);

  final NfcFailure failure;

  /// What to retry.
  final NfcAction action;
}

/// Drives the M1 spike screen: write a fresh test link to a sticker, or read
/// one. All tag logic lives in [NfcService]; this only tracks UI state.
@riverpod
class NfcSpikeController extends _$NfcSpikeController {
  @override
  NfcSpikeState build() {
    // Riverpod forbids ref.read inside onDispose, so capture the service now.
    final nfc = ref.read(nfcServiceProvider);
    ref.onDispose(() => unawaited(nfc.cancel()));
    return const NfcSpikeIdle();
  }

  NfcService get _nfc => ref.read(nfcServiceProvider);

  /// Writes a link with a new token, or with [token] when retrying after the
  /// user confirmed an overwrite.
  Future<void> write({TagToken? token, bool overwrite = false}) async {
    final tokenToWrite = token ?? TagToken.generate();
    state = const NfcSpikeWaiting(NfcAction.write);
    final result = await _nfc.writeLink(
      TagLink.build(tokenToWrite),
      overwrite: overwrite,
    );
    if (!ref.mounted) return;
    state = switch (result) {
      Success() => NfcSpikeWritten(tokenToWrite),
      Failure(failure: OverwriteNeedsConfirmation(:final existing)) =>
        NfcSpikeConfirmOverwrite(existing: existing, token: tokenToWrite),
      Failure(failure: NfcCancelled()) => const NfcSpikeIdle(),
      Failure(:final failure) => NfcSpikeFailed(failure, NfcAction.write),
    };
  }

  Future<void> confirmOverwrite() async {
    final current = state;
    if (current is NfcSpikeConfirmOverwrite) {
      await write(token: current.token, overwrite: true);
    }
  }

  Future<void> read() async {
    state = const NfcSpikeWaiting(NfcAction.read);
    final result = await _nfc.readTag();
    if (!ref.mounted) return;
    state = switch (result) {
      Success(:final value) => NfcSpikeRead(value),
      Failure(failure: NfcCancelled()) => const NfcSpikeIdle(),
      Failure(:final failure) => NfcSpikeFailed(failure, NfcAction.read),
    };
  }

  Future<void> retry() async {
    final current = state;
    if (current is NfcSpikeFailed) {
      await (current.action == NfcAction.write ? write() : read());
    }
  }

  Future<void> cancel() async {
    await _nfc.cancel();
    if (ref.mounted) state = const NfcSpikeIdle();
  }
}
