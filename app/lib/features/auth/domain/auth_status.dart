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

  /// Too many attempts; wait before trying again.
  rateLimited,

  /// The build or the backend lacks configuration for this provider (for
  /// example no Google client id, or the provider turned off).
  notConfigured,

  /// Anything else.
  unknown,
}
