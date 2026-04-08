import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_add_page.dart';
import 'package:sizer/sizer.dart';

void main() {
  final TestWidgetsFlutterBinding testWidgetsFlutterBinding =
      TestWidgetsFlutterBinding.ensureInitialized();

  // Set screen sizes and ratio
  testWidgetsFlutterBinding.window.physicalSizeTestValue = Size(1920, 1080);
  testWidgetsFlutterBinding.window.devicePixelRatioTestValue = 1.0;

  // widget tests for the add data page
  group("widget tests for the add data page", () {
    testWidgets("checking that there is a save button", (tester) async {
      await tester.pumpWidget(
        Sizer(
          builder: (context, orientation, deviceType) => const MaterialApp(
            home: DashboardAddPage(), // the page being tested
          ),
        ),
      );

      // Check if the add data header exists
      expect(find.text('Add Data'), findsOneWidget);

      // Check the site section
      expect(find.text('Site Information'), findsOneWidget);
      expect(find.byKey(Key('Site Information-Name')), findsOneWidget);
      expect(find.byKey(Key('Site Information-Borden')), findsOneWidget);
      expect(find.byKey(Key('Site Information-Area')), findsOneWidget);

      // Check the unit section
      expect(find.text('Unit'), findsOneWidget);
      expect(find.byKey(Key('Unit-Name')), findsOneWidget);
      expect(find.byKey(Key('Unit-Site Name')), findsOneWidget);

      // Check the level section
      expect(find.text('Level'), findsOneWidget);
      expect(find.byKey(Key('Level-Name')), findsOneWidget);
      expect(find.byKey(Key('Level-Unit Name')), findsOneWidget);
      expect(find.byKey(Key('Level-Parent Name')), findsOneWidget);
      expect(find.byKey(Key('Level-Upper Limit')), findsOneWidget);
      expect(find.byKey(Key('Level-Lower Limit')), findsOneWidget);

      // Check the assemblage section
      expect(find.text('Assemblage'), findsOneWidget);
      expect(find.byKey(Key('Assemblage-Assemblage Name')), findsOneWidget);
      expect(find.byKey(Key('Assemblage-Unit Name')), findsOneWidget);
      expect(find.byKey(Key('Assemblage-Level Name')), findsOneWidget);

      // Check the Artifact (Faunal) section
      expect(find.text('Artifact (Faunal)'), findsOneWidget);
      expect(
        find.byKey(Key('Artifact (Faunal)-Assemblage Name')),
        findsOneWidget,
      );
      expect(
        find.byKey(Key('Artifact (Faunal)-Porosity')),
        findsOneWidget,
      );
      expect(
        find.byKey(Key('Artifact (Faunal)-Size Upper')),
        findsOneWidget,
      );
      expect(
        find.byKey(Key('Artifact (Faunal)-Size Lower')),
        findsOneWidget,
      );
      expect(
        find.byKey(Key('Artifact (Faunal)-Comment')),
        findsOneWidget,
      );
      expect(
        find.byKey(Key('Artifact (Faunal)-Pre Excavation Fragments')),
        findsOneWidget,
      );
      expect(
        find.byKey(Key('Artifact (Faunal)-Post Excavation Fragments')),
        findsOneWidget,
      );
      expect(
        find.byKey(Key('Artifact (Faunal)-Elements')),
        findsOneWidget,
      );

      // ensuring there is at least 1 save button
      expect(find.byKey(Key("saveButton")), findsOneWidget);

      // Check the reset button
      expect(find.byKey(Key("resetButton")), findsOneWidget);

      // Enter and check text
      await tester.enterText(find.byKey(Key('Site Information-Name')), 'Test Text');
      await tester.pumpAndSettle();
      expect(find.text('Test Text'), findsOneWidget);

      // Check if pressing the reset button clears the entered text
      await tester.tap(find.byKey(Key("resetButton")));
      await tester.pumpAndSettle();
      expect(find.text('Test Text'), findsNothing);
    });
  });
}
