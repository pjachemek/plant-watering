/// A light check before asking the server to send a link: one `@`, something
/// before it, and a dotted domain after it, with no spaces. The server makes
/// the final decision.
final RegExp _plausible = RegExp(r'^[^@\s]+@[^@\s.]+(\.[^@\s.]+)+$');

/// The address as typed, trimmed and lower-cased, or `null` when it can't be
/// an email address.
String? normalizeEmail(String input) {
  final email = input.trim().toLowerCase();
  if (email.length > 254 || !_plausible.hasMatch(email)) return null;
  return email;
}
