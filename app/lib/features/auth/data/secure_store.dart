import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotrue/gotrue.dart';

/// Keychain / Keystore-backed storage for the session (NFR Security: session
/// tokens in Keystore; ADR-0021).
///
/// On Android the values are encrypted with a key held in the Android
/// Keystore. If that key is lost (for example after a device restore), the
/// store resets and the person signs in again instead of the app crashing.
class SecureStore extends GotrueAsyncStorage {
  new([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> getItem({required String key}) => _storage.read(key: key);

  @override
  Future<void> setItem({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> removeItem({required String key}) => _storage.delete(key: key);
}
