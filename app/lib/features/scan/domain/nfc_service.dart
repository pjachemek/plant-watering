import 'package:meta/meta.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/scan/domain/tag_token.dart';

/// Whether this phone can talk to NFC tags right now.
enum NfcAvailability { available, disabled, unsupported }

/// What a tag holds, as far as this app cares.
@immutable
sealed class TagContent {
  const new();
}

/// A formatted tag with no records.
final class EmptyTag extends TagContent {
  const new();

  @override
  bool operator ==(Object other) => other is EmptyTag;

  @override
  int get hashCode => (EmptyTag).hashCode;
}

/// One of our plant links.
final class PlantLinkTag extends TagContent {
  const new(this.token);

  final TagToken token;

  @override
  bool operator ==(Object other) =>
      other is PlantLinkTag && other.token == token;

  @override
  int get hashCode => token.hashCode;
}

/// Anything else: someone else's link, text, contact cards and so on.
final class ForeignDataTag extends TagContent {
  const new();

  @override
  bool operator ==(Object other) => other is ForeignDataTag;

  @override
  int get hashCode => (ForeignDataTag).hashCode;
}

/// Why a tag operation failed. Every case maps to a user-facing message with
/// a recovery action (AGENTS.md section 5).
@immutable
sealed class NfcFailure {
  const new();
}

/// NFC is off or missing on this phone.
final class NfcUnavailable extends NfcFailure {
  const new(this.availability);

  final NfcAvailability availability;
}

/// The tag can't hold NDEF data (wrong chip type).
final class TagNotNdef extends NfcFailure {
  const new();
}

/// The tag is locked.
final class TagReadOnly extends NfcFailure {
  const new();
}

/// The link doesn't fit on the tag.
final class TagTooSmall extends NfcFailure {
  const new({required this.neededBytes, required this.capacityBytes});

  final int neededBytes;
  final int capacityBytes;
}

/// The phone moved away from the tag mid-operation.
final class TagLost extends NfcFailure {
  const new();
}

/// The write went through but reading it back gave something else.
final class WriteNotVerified extends NfcFailure {
  const new();
}

/// The tag already holds data; the user must confirm before we overwrite it
/// (AGENTS.md section 7, write flow step 3).
final class OverwriteNeedsConfirmation extends NfcFailure {
  const new(this.existing);

  final TagContent existing;
}

/// The user or the app cancelled the session.
final class NfcCancelled extends NfcFailure {
  const new();
}

/// Anything the platform reported that we don't recognise. [code] is the
/// platform error code only, never tag contents.
final class NfcUnknownFailure extends NfcFailure {
  const new(this.code);

  final String code;
}

/// Platform NFC access, behind an interface so it can be faked in tests
/// (AGENTS.md section 5). Each call opens a user-initiated session that ends
/// when a tag has been handled or [cancel] is called (NFR Battery).
abstract interface class NfcService {
  Future<NfcAvailability> availability();

  /// Waits for one tag and reports what it holds.
  Future<Result<TagContent, NfcFailure>> readTag();

  /// Waits for one tag, writes [link] as the only record, reads it back and
  /// compares. If the tag already holds other data and [overwrite] is false,
  /// fails with [OverwriteNeedsConfirmation] without writing.
  Future<Result<void, NfcFailure>> writeLink(
    Uri link, {
    bool overwrite = false,
  });

  /// Ends the current session, if any. A pending call completes with
  /// [NfcCancelled].
  Future<void> cancel();
}
