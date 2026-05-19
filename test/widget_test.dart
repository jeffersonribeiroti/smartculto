import 'package:flutter_test/flutter_test.dart';
import 'package:smartculto/main.dart';

void main() {
  testWidgets('Aplicativo inicia corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartCultoApp());

    expect(find.text('SmartCulto'), findsOneWidget);
  });
}