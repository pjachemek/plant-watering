import 'dart:async';

/// Stream helpers the SDK lacks.
extension SwitchMap<T> on Stream<T> {
  /// Maps each event to a stream and follows only the latest one: when a
  /// new event arrives, the previous inner stream is cancelled.
  ///
  /// Unlike `asyncExpand`, which waits for each inner stream to finish (a
  /// live database query never does), this reacts to every event at once.
  Stream<R> switchMap<R>(Stream<R> Function(T event) convert) {
    late final StreamController<R> out;
    StreamSubscription<T>? outer;
    StreamSubscription<R>? inner;
    var outerDone = false;
    var innerDone = true;

    void closeIfDone() {
      if (outerDone && innerDone) unawaited(out.close());
    }

    out = StreamController<R>(
      onListen: () {
        outer = listen(
          (event) {
            unawaited(inner?.cancel());
            innerDone = false;
            inner = convert(event).listen(
              out.add,
              onError: out.addError,
              onDone: () {
                innerDone = true;
                closeIfDone();
              },
            );
          },
          onError: out.addError,
          onDone: () {
            outerDone = true;
            closeIfDone();
          },
        );
      },
      onPause: () {
        outer?.pause();
        inner?.pause();
      },
      onResume: () {
        outer?.resume();
        inner?.resume();
      },
      onCancel: () async {
        await inner?.cancel();
        await outer?.cancel();
      },
    );
    return out.stream;
  }
}
