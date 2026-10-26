import 'dart:async';

import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/scan/domain/nfc_service.dart';

/// In-memory [NfcService]. Each read or write waits until the test calls
/// [completeRead] or [completeWrite], like a user holding up a sticker.
class FakeNfcService implements NfcService {
  NfcAvailability availabilityValue = NfcAvailability.available;

  final List<({Uri link, bool overwrite})> writes = [];
  int reads = 0;
  int cancels = 0;

  Completer<Result<TagContent, NfcFailure>>? _read;
  Completer<Result<void, NfcFailure>>? _write;

  bool get waiting => _read != null || _write != null;

  @override
  Future<NfcAvailability> availability() async => availabilityValue;

  @override
  Future<Result<TagContent, NfcFailure>> readTag() {
    reads++;
    return (_read = Completer()).future;
  }

  @override
  Future<Result<void, NfcFailure>> writeLink(
    Uri link, {
    bool overwrite = false,
  }) {
    writes.add((link: link, overwrite: overwrite));
    return (_write = Completer()).future;
  }

  void completeRead(Result<TagContent, NfcFailure> result) {
    final read = _read!;
    _read = null;
    read.complete(result);
  }

  void completeWrite(Result<void, NfcFailure> result) {
    final write = _write!;
    _write = null;
    write.complete(result);
  }

  @override
  Future<void> cancel() async {
    cancels++;
    final read = _read;
    final write = _write;
    _read = null;
    _write = null;
    read?.complete(const Failure(NfcCancelled()));
    write?.complete(const Failure(NfcCancelled()));
  }
}
