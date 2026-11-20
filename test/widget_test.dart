import 'package:flutter_test/flutter_test.dart';
import 'package:production_login/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RealEstateApp());
    expect(find.byType(RealEstateApp), findsOneWidget);
  });
}
