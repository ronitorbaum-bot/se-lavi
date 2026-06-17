import 'package:flutter_test/flutter_test.dart';
import 'package:se_lavi/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SeLaviApp());
    expect(find.text('היום שלי'), findsWidgets);
  });
}
