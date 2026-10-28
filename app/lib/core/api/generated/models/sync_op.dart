// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

/// `upsert` creates or patches. `delete` soft-deletes; for a watering.
/// event it is the undo (AGENTS.md section 5). Households can't be deleted.
/// through sync.
///
@JsonEnum()
enum SyncOp {
  @JsonValue('upsert')
  upsert('upsert'),
  @JsonValue('delete')
  delete('delete'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const SyncOp(this.json);

  factory SyncOp.fromJson(String json) =>
      values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;
  String toJson() {
    final value = json;
    if (value == null) {
      throw StateError(
        'Cannot convert enum value with null JSON representation to String. '
        'This usually happens for \$unknown or @JsonValue(null) entries.',
      );
    }
    return value as String;
  }

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<SyncOp> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
