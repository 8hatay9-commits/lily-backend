import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kast_mobile_concept/app.dart';

void main() {
  Future<void> setSize(
    WidgetTester tester,
    Size size,
  ) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('mobile layout renders without exceptions', (tester) async {
    await setSize(tester, const Size(390, 844));
    await tester.pumpWidget(const KastConceptApp());
    await tester.pumpAndSettle();

    expect(find.text('Your computers'), findsOneWidget);
    expect(find.text('Workstation'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop layout renders without exceptions', (tester) async {
    await setSize(tester, const Size(1200, 900));
    await tester.pumpWidget(const KastConceptApp());
    await tester.pumpAndSettle();

    expect(find.text('Your computers'), findsOneWidget);
    expect(find.text('Build Server'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('device to window to session flow works', (tester) async {
    await setSize(tester, const Size(430, 900));
    await tester.pumpWidget(const KastConceptApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Workstation'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Choose a window on'), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'window picker must fit');

    await tester.tap(find.text('Visual Studio Code'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.text('Visual Studio Code'), findsWidgets);
    expect(find.text('Adaptive quality'), findsOneWidget);
    expect(find.textContaining('ms'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('terminal page accepts a demo command', (tester) async {
    await setSize(tester, const Size(430, 900));
    await tester.pumpWidget(const KastConceptApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Terminal'));
    await tester.pumpAndSettle();

    expect(find.text('Direct terminal mode'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'pwd');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('/home/ibrahim'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}