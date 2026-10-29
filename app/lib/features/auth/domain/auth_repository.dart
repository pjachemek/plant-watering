import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';

/// Sign-in and the access token for the API (FR-7, ADR-0021, ADR-0022).
/// Sign-in is through external identity providers only; Supabase Auth sits
/// behind it, and nothing else in the app knows that.
abstract interface class AuthRepository {
  /// The current status. Known at once after [restore], without network.
  AuthStatus get status;

  /// Every change of [status], for example after signing out on a revoked
  /// session.
  Stream<AuthStatus> get statusChanges;

  /// Loads the saved session from secure storage. Works offline, so the app
  /// opens signed in without waiting for the network.
  Future<void> restore();

  /// Google account picker, then a Supabase session.
  Future<Result<void, AuthFailure>> signInWithGoogle();

  /// A valid access token, refreshed when needed, or `null` when signed out.
  Future<String?> accessToken();

  /// Signs out on this device and forgets the saved session.
  Future<void> signOut();
}
