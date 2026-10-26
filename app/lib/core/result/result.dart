import 'package:meta/meta.dart';

/// A value or a typed failure. Domain and data layers return this instead of
/// throwing, so no unhandled exception reaches the UI (AGENTS.md section 5).
@immutable
sealed class Result<T, F> {
  const new();

  bool get isSuccess => this is Success<T, F>;

  bool get isFailure => this is Failure<T, F>;

  /// The value, or `null` on failure.
  T? get valueOrNull => switch (this) {
    Success(:final value) => value,
    Failure() => null,
  };

  /// Collapses both cases into one value.
  R fold<R>(R Function(T value) onSuccess, R Function(F failure) onFailure) =>
      switch (this) {
        Success(:final value) => onSuccess(value),
        Failure(:final failure) => onFailure(failure),
      };

  /// Transforms the value, keeping failures as they are.
  Result<R, F> map<R>(R Function(T value) transform) => switch (this) {
    Success(:final value) => Success(transform(value)),
    Failure(:final failure) => Failure(failure),
  };
}

final class Success<T, F> extends Result<T, F> {
  const new(this.value);

  final T value;

  @override
  bool operator ==(Object other) =>
      other is Success<T, F> && other.value == value;

  @override
  int get hashCode => Object.hash(Success, value);

  @override
  String toString() => 'Success($value)';
}

final class Failure<T, F> extends Result<T, F> {
  const new(this.failure);

  final F failure;

  @override
  bool operator ==(Object other) =>
      other is Failure<T, F> && other.failure == failure;

  @override
  int get hashCode => Object.hash(Failure, failure);

  @override
  String toString() => 'Failure($failure)';
}
