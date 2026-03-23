import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_add_page.dart';
import 'package:sizer/sizer.dart';

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized();

  // for creating the widget to be tested
  Widget createTestWidget(Widget child) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(home: child);
      },
    );
  }

  // widget tests for the add data page
  group("widget tests for the add data page", () {
    // widget test for the save button
    testWidgets("checking that there is a save button", (tester) async {
      // await tester.pumpWidget(const DashboardAddPage());
      // await tester.pumpWidget(
      //   Sizer(
      //     builder: (context, orientation, deviceType) => const MaterialApp(
      //       home: DashboardAddPage(), // the page being tested
      //     ),
      //   ),
      // );
      await tester.pumpWidget(createTestWidget(const DashboardAddPage()));

      // ensuring there is at least 1 save button
      expect(find.byKey(Key("saveButton")), findsAny);
    });

    // widget test for the reset button
    testWidgets("checking that there is a reset button", (tester) async {
      // await tester.pumpWidget(const DashboardAddPage());
      // await tester.pumpWidget(
      //   Sizer(
      //     builder: (context, orientation, deviceType) => const MaterialApp(
      //       home: DashboardAddPage(), // the page being tested
      //     ),
      //   ),
      // );
      await tester.pumpWidget(createTestWidget(const DashboardAddPage()));

      // ensuring there is at least 1 reset button
      expect(find.byKey(Key("resetButton")), findsAny);
    });
  });
}
