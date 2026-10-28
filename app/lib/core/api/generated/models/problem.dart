// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'validation_issue.dart';

part 'problem.freezed.dart';
part 'problem.g.dart';

@Freezed()
abstract class Problem with _$Problem {
  const factory Problem({
    /// Stable machine-readable code, for example `not_found`.
    required String type,
    required String title,
    required int status,

    /// Never contains user data.
    String? detail,

    /// For 400 responses, where the request breaks the contract. Never echoes submitted values.
    List<ValidationIssue>? errors,
  }) = _Problem;

  factory Problem.fromJson(Map<String, Object?> json) =>
      _$ProblemFromJson(json);
}
