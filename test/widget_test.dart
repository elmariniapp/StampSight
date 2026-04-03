import 'package:flutter_test/flutter_test.dart';
import 'package:stampsight/app/app.dart';
import 'package:stampsight/app/routes/routing_state.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    AppRoutingState.instance.onboardingComplete = true;
    await tester.pumpWidget(const StampSightApp());
    await tester.pumpAndSettle();

    expect(find.text('StampSight'), findsWidgets);
  });
}
