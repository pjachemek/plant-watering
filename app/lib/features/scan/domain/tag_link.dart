import 'package:plantnfc/features/scan/domain/tag_token.dart';

/// The only content written to a tag: `https://<host>/p/<token>`
/// (AGENTS.md section 7). Parsing is strict so foreign links are never
/// mistaken for ours.
abstract final class TagLink {
  static const String host = 'plants.pampait.pl';
  static const String pathPrefix = 'p';

  static Uri build(TagToken token) =>
      Uri(scheme: 'https', host: host, pathSegments: [pathPrefix, token.value]);

  /// Returns the token for one of our tag links, otherwise `null`.
  /// Accepts a trailing slash; rejects other hosts, schemes, ports,
  /// credentials, extra path segments and malformed tokens.
  static TagToken? parse(Uri uri) {
    if (uri.scheme != 'https' ||
        uri.host.toLowerCase() != host ||
        uri.hasPort ||
        uri.userInfo.isNotEmpty) {
      return null;
    }
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.length != 2 || segments.first != pathPrefix) return null;
    return TagToken.tryParse(segments.last);
  }

  /// Like [parse] but for raw text, for example an NDEF URI record.
  static TagToken? parseString(String text) {
    final uri = Uri.tryParse(text.trim());
    return uri == null ? null : parse(uri);
  }
}
