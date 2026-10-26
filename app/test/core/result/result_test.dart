import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/result/result.dart';

void main() {
  const Result<int, String> ok = Success(2);
  const Result<int, String> err = Failure('boom');

  test('flags', () {
    expect(ok.isSuccess, isTrue);
    expect(ok.isFailure, isFalse);
    expect(err.isSuccess, isFalse);
    expect(err.isFailure, isTrue);
  });

  test('valueOrNull', () {
    expect(ok.valueOrNull, 2);
    expect(err.valueOrNull, isNull);
  });

  test('fold', () {
    expect(ok.fold((v) => 'v$v', (f) => 'f$f'), 'v2');
    expect(err.fold((v) => 'v$v', (f) => 'f$f'), 'fboom');
  });

  test('map transforms success and keeps failure', () {
    expect(ok.map((v) => v * 10), const Success<int, String>(20));
    expect(err.map((v) => v * 10), const Failure<int, String>('boom'));
  });

  test('value equality, hashCode and toString', () {
    expect(const Success<int, String>(2), ok);
    expect(const Success<int, String>(2).hashCode, ok.hashCode);
    expect(const Failure<int, String>('boom'), err);
    expect(const Failure<int, String>('boom').hashCode, err.hashCode);
    expect(ok, isNot(err));
    expect(ok.toString(), 'Success(2)');
    expect(err.toString(), 'Failure(boom)');
  });
}
