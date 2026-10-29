import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/streams/switch_map.dart';

void main() {
  test('follows the latest inner stream, even when it never ends', () async {
    final outer = StreamController<String>();
    final inners = <String, StreamController<String>>{};
    final seen = <String>[];

    final sub = outer.stream
        .switchMap((key) => (inners[key] = StreamController<String>()).stream)
        .listen(seen.add);

    outer.add('a');
    await pumpEventQueue();
    inners['a']!.add('a1');
    await pumpEventQueue();

    // A live query never closes: the next outer event must still count.
    outer.add('b');
    await pumpEventQueue();
    inners['a']!.add('a2'); // from the old one: dropped
    inners['b']!.add('b1');
    await pumpEventQueue();

    expect(seen, ['a1', 'b1']);
    expect(inners['a']!.hasListener, isFalse);

    await sub.cancel();
    expect(inners['b']!.hasListener, isFalse);
    expect(outer.hasListener, isFalse);
  });

  test('closes when the outer and the last inner stream are done', () async {
    final done = Completer<void>();
    Stream.fromIterable([1, 2])
        .switchMap((n) => Stream.value(n * 10))
        .listen(null, onDone: done.complete);

    await done.future.timeout(const Duration(seconds: 1));
  });
}
