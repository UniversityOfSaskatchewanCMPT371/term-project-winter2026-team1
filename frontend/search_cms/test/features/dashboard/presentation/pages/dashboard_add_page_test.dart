import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_add_page.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: child,
    );
  }

  group('DashboardAddPage widget tests', () {

    testWidgets('renders add data page without crashing',
        (WidgetTester tester) async {

      await tester.pumpWidget(buildTestableWidget(const DashboardAddPage()));
      await tester.pumpAndSettle();

      expect(find.byType(DashboardAddPage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('renders add page app bar title',
        (WidgetTester tester) async {

      await tester.pumpWidget(buildTestableWidget(const DashboardAddPage()));
      await tester.pumpAndSettle();

      expect(find.text('Add Placeholder'), findsOneWidget);
    });

    testWidgets('renders add page placeholder body text',
        (WidgetTester tester) async {

      await tester.pumpWidget(buildTestableWidget(const DashboardAddPage()));
      await tester.pumpAndSettle();

      expect(find.text('Add Page TODO'), findsOneWidget);
    });

  });
}