import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/api/generated/export.dart';

/// Shared with the Worker's tests (functions/test/contract-fixtures.test.ts):
/// both sides must agree on these payloads, or one of them fails (ADR-0015).
Map<String, Object?> fixture(String name) => jsonDecode(
  File('../functions/test/fixtures/contract/$name').readAsStringSync(),
) as Map<String, Object?>;

/// Encodes like the HTTP client does: nested models through their toJson.
Object? encode(Object model) => jsonDecode(jsonEncode(model));

void main() {
  test('push_request.json round-trips unchanged, nulls omitted', () {
    final json = fixture('push_request.json');

    final request = PushRequest.fromJson(json);

    expect(encode(request), json);
    expect(request.changes.first.fields, ['nickname', 'preset_id', 'room']);
    expect(request.changes.first.plant?.room, isNull);
  });

  test('pull_response.json round-trips unchanged', () {
    final json = fixture('pull_response.json');

    final response = PullResponse.fromJson(json);

    expect(encode(response), json);
    expect(response.plants.single.method, WateringMethod.top);
  });

  test('parses tolerantly: unknown fields and enum values never fail', () {
    final json = fixture('pull_response.json');
    final household = Map<String, Object?>.of(
      json['household']! as Map<String, Object?>,
    )..addAll({'hemisphere': 'equator', 'added_in_a_later_version': true});
    final plants = [
      Map<String, Object?>.of(
        (json['plants']! as List<Object?>).single! as Map<String, Object?>,
      )..['method'] = 'drip',
    ];

    final response = PullResponse.fromJson({
      ...json,
      'household': household,
      'plants': plants,
      'server_hint': 'ignored',
    });

    expect(response.household.hemisphere, Hemisphere.$unknown);
    expect(response.plants.single.method, WateringMethod.$unknown);
  });
}
