// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'timestamp.dart';
import 'uuid.dart';

part 'member.freezed.dart';
part 'member.g.dart';

@Freezed()
abstract class Member with _$Member {
  const factory Member({
    required Uuid id,
    @JsonKey(name: 'household_id') required Uuid householdId,
    @JsonKey(name: 'user_id') required Uuid userId,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'joined_at') required Timestamp joinedAt,
    @JsonKey(name: 'updated_at') required Timestamp updatedAt,
    @JsonKey(name: 'deleted_at') Timestamp? deletedAt,
  }) = _Member;

  factory Member.fromJson(Map<String, Object?> json) => _$MemberFromJson(json);
}
