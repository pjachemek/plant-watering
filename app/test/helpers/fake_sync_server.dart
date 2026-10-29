import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:plantnfc/core/api/generated/plant_api_client.dart';

import 'fake_http_adapter.dart';

/// A small in-memory stand-in for the sync API (ADR-0019), enough to test
/// the app's engine against the same rules: a change ledger keyed by change
/// id, per-field last write wins, append-only waterings, soft deletes,
/// unique tag tokens, and an integer cursor. The real rules are tested in
/// functions/test/sync.test.ts.
class FakeSyncServer {
  new({required this.householdId});

  final String householdId;

  bool offline = false;

  /// Applies the next push, then drops its answer (a timeout after the
  /// server committed).
  bool loseNextPushAnswer = false;

  /// Households the caller belongs to; empty after leaving.
  late List<String> memberOf = [householdId];

  /// Runs just before a pull answers (to simulate edits during a sync).
  void Function()? beforePull;

  int _xid = 1;
  final Map<String, Map<String, Object?>> plants = {};
  final Map<String, Map<String, Object?>> tags = {};
  final Map<String, Map<String, Object?>> waterings = {};
  final Map<String, ({String key, Map<String, Object?> result})> ledger = {};
  final List<String> pushKeys = [];

  static const String _time = '2026-10-29T08:00:00.000Z';

  Map<String, Object?> get _household => {
    'id': householdId,
    'name': 'Home',
    'public_cards_enabled': false,
    'hemisphere': 'north',
    'created_at': _time,
    'updated_at': _time,
  };

  /// An API client for one device, as [userId], talking to this server.
  PlantApiClient clientFor(String userId) {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test/v1'))
      ..httpClientAdapter = FakeHttpAdapter(
        (request) => _handle(request, userId),
      );
    return PlantApiClient(dio);
  }

  (int, Object?) _handle(RequestOptions request, String userId) {
    if (offline) {
      throw DioException.connectionError(
        requestOptions: request,
        reason: 'offline',
      );
    }
    switch (request.path) {
      case '/households':
        return (
          200,
          {
            'households': [if (memberOf.contains(householdId)) _household],
          },
        );
      case '/sync/push':
        if (!memberOf.contains(householdId)) return (404, null);
        final key = request.headers['Idempotency-Key'] as String;
        pushKeys.add(key);
        // As it arrives on the wire: Dio encodes the nested models.
        final body =
            (request.data is String
                    ? jsonDecode(request.data as String)
                    : jsonDecode(jsonEncode(request.data)))
                as Map<String, Object?>;
        final changes = (body['changes']! as List<Object?>)
            .cast<Map<String, Object?>>();
        final results = [for (final c in changes) _push(c, key, userId)];
        if (loseNextPushAnswer) {
          loseNextPushAnswer = false;
          throw DioException.connectionTimeout(
            timeout: const Duration(seconds: 20),
            requestOptions: request,
          );
        }
        return (200, {'results': results});
      case '/sync/pull':
        if (!memberOf.contains(householdId)) return (404, null);
        beforePull?.call();
        final raw = request.queryParameters['cursor'] as String?;
        final from = raw == null ? 0 : int.parse(raw);
        List<Map<String, Object?>> since(Map<String, Map<String, Object?>> t) =>
            [
              for (final row in t.values)
                if ((row['_xid']! as int) >= from) {...row}..remove('_xid'),
            ];
        return (
          200,
          {
            'cursor': '$_xid',
            'household': _household,
            'members': <Object?>[],
            'plants': since(plants),
            'tags': since(tags),
            'watering_events': since(waterings),
          },
        );
    }
    return (404, null);
  }

  Map<String, Object?> _push(
    Map<String, Object?> c,
    String key,
    String userId,
  ) {
    final changeId = c['change_id']! as String;
    final seen = ledger[changeId];
    if (seen != null) {
      return seen.key == key || seen.result['status'] == 'rejected'
          ? seen.result
          : {'change_id': changeId, 'status': 'duplicate'};
    }
    final status = _apply(c, userId);
    final result = {
      'change_id': changeId,
      'status': status == null ? 'applied' : 'rejected',
      if (status != null)
        'problem': {'type': status, 'title': 'Rejected', 'status': 422},
    };
    ledger[changeId] = (key: key, result: result);
    return result;
  }

  /// Applies one change; returns the rejection type, or null.
  String? _apply(Map<String, Object?> c, String userId) {
    final entity = c['entity']! as String;
    final id = c['id']! as String;
    final op = c['op']! as String;
    final patch = (c[entity] as Map<String, Object?>?) ?? const {};
    final fields =
        (c['fields'] as List<Object?>?)?.cast<String>() ?? patch.keys.toList();
    final xid = _xid++;
    switch (entity) {
      case 'plant':
        final row = plants[id];
        if (op == 'delete') {
          if (row == null) return 'not_found';
          row
            ..['deleted_at'] ??= _time
            ..['_xid'] = xid;
          return null;
        }
        if (row?['deleted_at'] != null) return 'not_found';
        final next = {
          ...?row,
          for (final f in fields) f: patch[f],
          'id': id,
          'household_id': householdId,
          'created_at': row?['created_at'] ?? _time,
          'updated_at': _time,
          '_xid': xid,
        };
        final custom = next['preset_id'] == null;
        if (next['nickname'] == null ||
            (custom && next['interval_summer_days'] == null)) {
          return 'invalid_change';
        }
        plants[id] = next;
        return null;
      case 'watering_event':
        if (op == 'delete') {
          final row = waterings[id];
          if (row == null) return 'not_found';
          row
            ..['deleted_at'] ??= _time
            ..['_xid'] = xid;
          return null;
        }
        waterings.putIfAbsent(
          id,
          () => {
            ...patch,
            'id': id,
            'household_id': householdId,
            'user_id': userId,
            'created_at': _time,
            '_xid': xid,
          },
        );
        return null;
      case 'tag':
        final token = patch['token'];
        if (tags.values.any((t) => t['token'] == token && t['id'] != id)) {
          return 'conflict';
        }
        tags[id] = {
          ...?tags[id],
          for (final f in fields) f: patch[f],
          'id': id,
          'household_id': householdId,
          'updated_at': _time,
          '_xid': xid,
        };
        return null;
    }
    return 'invalid_change';
  }
}
