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

  /// Where email sign-in links land: a verified App Link, so the link opens
  /// this app, and only on the phone that asked for it (ADR-0021). Must be in
  /// the Supabase project's redirect URL allow list.
  static final Uri authRedirect = Uri.parse(
    'https://plants.pampait.pl/auth/callback',
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
  /// Public by design (every Google sign-in app ships one). Empty hides
  /// Google sign-in.
  final String googleWebClientId;

  /// Empty disables error reporting (the default for local runs and tests).
  final String sentryDsn;

  bool get errorReportingEnabled => sentryDsn.isNotEmpty;
}
