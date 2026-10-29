import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  late int signOuts;

  setUp(() => signOuts = 0);

  Future<void> pump(WidgetTester tester, {required int queued}) =>
      pumpApp(tester, outboxSize: queued, signOut: () async => signOuts++);

  testWidgets('signs out at once when everything has been sent', (
    tester,
  ) async {
    await pump(tester, queued: 0);

    await tester.tap(find.byTooltip('Sign out'));
    await tester.pumpAndSettle();

    expect(signOuts, 1);
  });

  testWidgets('warns about unsent changes before deleting them', (
    tester,
  ) async {
    await pump(tester, queued: 2);

    await tester.tap(find.byTooltip('Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Sign out with unsent changes?'), findsOneWidget);
    expect(find.textContaining('2 changes made on this phone'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(signOuts, 0);

    await tester.tap(find.byTooltip('Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out anyway'));
    await tester.pumpAndSettle();
    expect(signOuts, 1);
  });
}
