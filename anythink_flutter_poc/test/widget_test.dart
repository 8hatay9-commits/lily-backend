import 'package:anythink_sdk_demo/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('playground renders core SDK sections', (tester) async {
    await tester.pumpWidget(const DemoApp());

    expect(find.text('Anythink SDK Playground'), findsOneWidget);
    expect(find.text('Authentication'), findsOneWidget);
    expect(find.text('Storage'), findsWidgets);
    expect(find.text('REST health check'), findsOneWidget);
  });
}