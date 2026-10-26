import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/features/scan/domain/tag_link.dart';
import 'package:plantnfc/features/scan/domain/tag_token.dart';

void main() {
  const raw = 'AbCdEfGhIjKlMnOpQrStUv';
  final token = TagToken.tryParse(raw)!;

  test('build produces the tag URL', () {
    expect(TagLink.build(token).toString(), 'https://plants.pampait.pl/p/$raw');
  });

  test('build and parse round-trip', () {
    final generated = TagToken.generate();

    expect(TagLink.parse(TagLink.build(generated)), generated);
  });

  group('parse accepts', () {
    for (final url in [
      'https://plants.pampait.pl/p/$raw',
      'https://plants.pampait.pl/p/$raw/',
      'https://PLANTS.pampait.pl/p/$raw',
      '  https://plants.pampait.pl/p/$raw  ',
    ]) {
      test(url, () => expect(TagLink.parseString(url), token));
    }
  });

  group('parse rejects', () {
    for (final url in [
      'http://plants.pampait.pl/p/$raw',
      'https://evil.example/p/$raw',
      'https://plants.pampait.pl.evil.example/p/$raw',
      'https://plants.pampait.pl:8443/p/$raw',
      'https://user@plants.pampait.pl/p/$raw',
      'https://plants.pampait.pl/q/$raw',
      'https://plants.pampait.pl/p/$raw/extra',
      'https://plants.pampait.pl/p/',
      'https://plants.pampait.pl/p/short',
      'plants.pampait.pl/p/$raw',
      'not a url at all %%%',
      '',
    ]) {
      test(url.isEmpty ? '(empty)' : url, () {
        expect(TagLink.parseString(url), isNull);
      });
    }
  });
}
