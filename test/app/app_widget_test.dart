import 'package:flutter_test/flutter_test.dart';
import 'package:number_raffler/app/app_widget.dart';

void main() {
  testWidgets('app widget renders home page', (tester) async {
    await tester.pumpWidget(const AppWidget());

    expect(find.text('Numbers'), findsOneWidget);
  });
}
