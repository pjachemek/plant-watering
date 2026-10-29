import 'package:gotrue/gotrue.dart';
import 'package:plantnfc/core/config/app_config.dart';
import 'package:plantnfc/core/config/config_provider.dart';
import 'package:plantnfc/features/auth/data/google_id_token_source.dart';
import 'package:plantnfc/features/auth/data/gotrue_auth_repository.dart';
import 'package:plantnfc/features/auth/data/secure_store.dart';
import 'package:plantnfc/features/auth/domain/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

/// Sign-in for the whole app. `main` calls [AuthRepository.restore] before
/// the first frame; tests override this with a fake.
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final config = ref.watch(appConfigProvider);
  final store = SecureStore();
  final repository = GoTrueAuthRepository(
    client: GoTrueClient(
      url: '${config.supabaseUrl}/auth/v1',
      headers: {'apikey': config.supabaseAnonKey},
      asyncStorage: store,
    ),
    store: store,
    google: PluginGoogleIdTokenSource(serverClientId: config.googleWebClientId),
    emailRedirect: AppConfig.authRedirect,
  );
  ref.onDispose(repository.dispose);
  return repository;
}
