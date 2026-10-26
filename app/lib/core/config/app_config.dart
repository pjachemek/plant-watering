/// Build-time configuration passed with `--dart-define` or
/// `--dart-define-from-file`. Nothing secret lives here: the Supabase anon key
/// is public by design and access is enforced by RLS (AGENTS.md section 6).
class AppConfig {
  const new({
    required this.environment,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.sentryDsn,
  });

  factory fromEnvironment() => const AppConfig(
    environment: String.fromEnvironment('APP_ENV', defaultValue: 'dev'),
    supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
    supabaseAnonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
    sentryDsn: String.fromEnvironment('SENTRY_DSN'),
  );

  /// `dev`, `staging` or `production`.
  final String environment;
  final String supabaseUrl;
  final String supabaseAnonKey;

  /// Empty disables error reporting (the default for local runs and tests).
  final String sentryDsn;

  bool get errorReportingEnabled => sentryDsn.isNotEmpty;
}
