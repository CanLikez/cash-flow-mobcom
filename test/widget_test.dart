import 'package:flutter_test/flutter_test.dart';
import 'package:cash_flow/main.dart';

void main() {
  testWidgets('CashFlowApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CashFlowApp());

    // Verify that the title appears.
    expect(find.text('Cash Flow Harian'), findsOneWidget);
  });
}
