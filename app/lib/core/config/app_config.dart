/// Build-time configuration passed with `--dart-define` or
/// `--dart-define-from-file`. Nothing secret lives here: the Supabase anon key
/// is public by design and is used for sign-in only (AGENTS.md section 6).
class AppConfig {
  const new({
    required this.environment,
    required this.apiBaseUrl,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.sentryDsn,
    required this.googleWebClientId,
  });

  factory fromEnvironment() => const AppConfig(
    environment: String.fromEnvironment('APP_ENV', defaultValue: 'dev'),
    apiBaseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.plants.pampait.pl/v1',
    ),
    supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
    supabaseAnonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
    sentryDsn: String.fromEnvironment('SENTRY_DSN'),
    googleWebClientId: String.fromEnvironment('GOOGLE_WEB_CLIENT_ID'),
  );

  /// `dev`, `staging` or `production`.
  final String environment;

  /// The versioned API, the only backend the app reads or writes data
  /// through (ADR-0012).
  final String apiBaseUrl;

  /// Supabase Auth only: sign-in and token refresh. The app never calls
  /// Supabase tables, storage or realtime directly.
  final String supabaseUrl;
  final String supabaseAnonKey;

  /// The Google OAuth "Web" client id that Supabase accepts ID tokens for.
  /// Public by design (every Google sign-in app ships one). Empty leaves
  /// the build without a way to sign in, which the sign-in screen says.
  final String googleWebClientId;

  /// Empty disables error reporting (the default for local runs and tests).
  final String sentryDsn;

  bool get errorReportingEnabled => sentryDsn.isNotEmpty;
}
