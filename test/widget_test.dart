import 'package:flutter_test/flutter_test.dart';
import 'package:shule_direct/core/constants/import_files.dart';

void main() {
  testWidgets('AppText renders label', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppText('Hello'),
        ),
      ),
    );

    expect(find.text('Hello'), findsOneWidget);
  });
}
