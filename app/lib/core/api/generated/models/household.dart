// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'hemisphere.dart';
import 'timestamp.dart';
import 'uuid.dart';

part 'household.freezed.dart';
part 'household.g.dart';

@Freezed()
abstract class Household with _$Household {
  const factory Household({
    required Uuid id,
    required String name,
    @JsonKey(name: 'public_cards_enabled') required bool publicCardsEnabled,
    required Hemisphere hemisphere,
    @JsonKey(name: 'created_at') required Timestamp createdAt,
    @JsonKey(name: 'updated_at') required Timestamp updatedAt,
    @JsonKey(name: 'deleted_at') Timestamp? deletedAt,
  }) = _Household;

  factory Household.fromJson(Map<String, Object?> json) =>
      _$HouseholdFromJson(json);
}
