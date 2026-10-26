import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/features/scan/domain/nfc_service.dart';
import 'package:plantnfc/features/scan/domain/tag_token.dart';

const TagTooSmall Function({
  required int capacityBytes,
  required int neededBytes,
})
_make = TagTooSmall.new;

/// Calls [create] at runtime, so the instance is never a shared const.
T _runtime<T>(T Function() create) => create();

void main() {
  group('TagContent equality', () {
    // Runtime instances, so equality is by value rather than identity.
    final token = TagToken.generate();
    final emptyA = _runtime(EmptyTag.new);
    final emptyB = _runtime(EmptyTag.new);
    final foreignA = _runtime(ForeignDataTag.new);
    final foreignB = _runtime(ForeignDataTag.new);

    test('empty tags are equal', () {
      expect(emptyA, emptyB);
      expect(emptyA.hashCode, emptyB.hashCode);
    });

    test('foreign tags are equal', () {
      expect(foreignA, foreignB);
      expect(foreignA.hashCode, foreignB.hashCode);
    });

    test('plant links are equal only for the same token', () {
      expect(PlantLinkTag(token), PlantLinkTag(token));
      expect(PlantLinkTag(token).hashCode, PlantLinkTag(token).hashCode);
      expect(PlantLinkTag(token), isNot(PlantLinkTag(TagToken.generate())));
    });

    test('different kinds are never equal', () {
      expect(emptyA, isNot(foreignA));
      expect(foreignA, isNot(PlantLinkTag(token)));
      expect(PlantLinkTag(token), isNot(emptyA));
    });
  });

  test('TagTooSmall carries the sizes for diagnostics', () {
    final failure = _runtime(() => _make(neededBytes: 60, capacityBytes: 40));

    expect(failure.neededBytes, 60);
    expect(failure.capacityBytes, 40);
  });
}
