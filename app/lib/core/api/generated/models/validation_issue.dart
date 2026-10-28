// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'validation_issue_location.dart';

part 'validation_issue.freezed.dart';
part 'validation_issue.g.dart';

@Freezed()
abstract class ValidationIssue with _$ValidationIssue {
  const factory ValidationIssue({
    required ValidationIssueLocation location,

    /// Dotted path to the offending field, for example `changes.0.plant.nickname`.
    required String pointer,

    /// Validator issue code, for example `too_small`.
    required String code,
  }) = _ValidationIssue;

  factory ValidationIssue.fromJson(Map<String, Object?> json) =>
      _$ValidationIssueFromJson(json);
}
