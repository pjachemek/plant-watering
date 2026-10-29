import 'package:meta/meta.dart';

/// Whether someone is signed in on this device (FR-7).
@immutable
sealed class AuthStatus {
  const new();
}

final class SignedOut extends AuthStatus {
  const new();

  @override
  bool operator ==(Object other) => other is SignedOut;

  @override
  int get hashCode => (SignedOut).hashCode;

  @override
  String toString() => 'SignedOut()';
}

/// Signed in. Holds the account id only: no email or name, so it is safe to
/// pass around and log (NFR Privacy).
final class SignedIn extends AuthStatus {
  const new(this.userId);

  final String userId;

  @override
  bool operator ==(Object other) => other is SignedIn && other.userId == userId;

  @override
  int get hashCode => Object.hash(SignedIn, userId);

  @override
  String toString() => 'SignedIn()';
}

/// Why a sign-in step failed. Each one has its own message and recovery
/// action on screen (AGENTS.md section 5).
enum AuthFailure {
  /// The person closed the account picker. Not an error: nothing is shown.
  cancelled,

  /// No connection, or the server didn't answer. Retry later.
  network,

  /// The email address isn't one we can send to.
  invalidEmail,

  /// Too many link requests; wait before asking again.
  rateLimited,

  /// The email link was used, expired, or opened on another phone.
  linkInvalid,

  /// The build lacks configuration (for example the Google client id).
  notConfigured,

  /// Anything else.
  unknown,
}
