import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/injections.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_add_page.dart';
import 'package:sizer/sizer.dart';

// A standard wrapper for widget tests that are being condemmed
Widget wrap(Widget child) {
  return Sizer(
    builder: (_, __, ___) {
      return MaterialApp(home: child);
    },
  );
}

// Helper function that fills valid inputs and submits the form
//
// Preconditions:
// - The Add Data page fully renders within the loaded state
// - Valid input values are passed into the helper function
//
// Postconditions:
// - All required Add Data fields are filled with valid values
// - The save button is being pressed and the form submission completes

Future<void> fillAllRequiredFields(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const Key('Site Information-Name')),
    'DiRx-28',
  );
  await tester.enterText(
    find.byKey(const Key('Site Information-Borden')),
    '1234',
  );
  await tester.enterText(
    find.byKey(const Key('Site Information-Area')),
    'Area A',
  );

  await tester.enterText(
    find.byKey(const Key('Unit-Name')),
    'N84SW1',
  );
  await tester.enterText(
    find.byKey(const Key('Unit-Site Name')),
    'DiRx-28',
  );

  await tester.enterText(
    find.byKey(const Key('Level-Name')),
    'Level 1',
  );
  await tester.enterText(
    find.byKey(const Key('Level-Unit Name')),
    'N84SW1',
  );
  await tester.enterText(
    find.byKey(const Key('Level-Parent Name')),
    'Parent A',
  );
  await tester.enterText(
    find.byKey(const Key('Level-Upper Limit')),
    '2',
  );
  await tester.enterText(
    find.byKey(const Key('Level-Lower Limit')),
    '1',
  );

  await tester.enterText(
    find.byKey(const Key('Assemblage-Assemblage Name')),
    'Level 1 Faunal',
  );
  await tester.enterText(
    find.byKey(const Key('Assemblage-Unit Name')),
    'N84SW1',
  );
  await tester.enterText(
    find.byKey(const Key('Assemblage-Level Name')),
    'Level 1',
  );

  await tester.enterText(
    find.byKey(const Key('Artifact (Faunal)-Assemblage Name')),
    'Level 1 Faunal',
  );
}
// Start test
void main() {

  final Logger? logger = 
    logLevel != Level.OFF ? Logger('Add Data System Test') : null;
    
    setUpAll(() async {
    // Reset GetIt before registering to avoid double registration
    // across each of the test runs
      await GetIt.instance.reset();
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
      await initInjections();
    });
            
//System Testing - 01 (SYS ADD-DATA-01)

//Site Information failure case

// Preconditions:
// - The Add Data page fully renders within the loaded state
//
// Postconditions:
// - Errors are properly handled and Site Information missing fields are show

  group('SYS-ADD-01 - Site Information Failure Case', () {
    testWidgets(
      'missing Borden and Area leads to SaveIncomplete and error message',
      (WidgetTester tester) async {

        logger?.info('Running site information failure case');

        //Uses the helpers to build the Add Data page
        await tester.pumpWidget(wrap(const DashboardAddPage()));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('Site Information-Name')),
          'DiRx-28',
        );

        // The "save button" is being tap and waits for the UI and validation to complete
        await tester.tap(find.byKey(const Key('saveButton')));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // SaveIncomplete indicates missing required Site Information fields (Borden and Area) and displays validation errors
        expect(find.textContaining('Missing required fields:'), findsOneWidget);
        expect(find.textContaining('Site Information: Borden'), findsOneWidget);
        expect(find.textContaining('Site Information: Area'), findsOneWidget);

        logger?.info('Site information failure case finished');
      },
    );
  });

// System Testing - 02 (SYS ADD-DATA-02)
//
// Unit failure case
//
// Preconditions:
// - The Add Data page fully renders within the loaded state
// - Site Information fields are filled
//
// Postconditions:
// - Errors are properly handled and the missing Unit Site Name field is shown

group('SYS-ADD-02 - Unit Failure Case', () {
  testWidgets(
    'missing Unit Site Name leads to SaveIncomplete and error message',
    (WidgetTester tester) async {
      logger?.info('Running unit failure case');

      // Uses the helper to build the Add Data page
      await tester.pumpWidget(wrap(const DashboardAddPage()));
      await tester.pumpAndSettle();

      // Enters valid Site Information fields
      await tester.enterText(
        find.byKey(const Key('Site Information-Name')),
        'DiRx-28',
      );
      await tester.enterText(
        find.byKey(const Key('Site Information-Borden')),
        '1234',
      );
      await tester.enterText(
        find.byKey(const Key('Site Information-Area')),
        'Western End of Slope',
      );

      // Enters only the Unit Name field
      await tester.enterText(
        find.byKey(const Key('Unit-Name')),
        'N84SW1',
      );

      // Taps the save button and waits for validation and UI updates to finish
      await tester.tap(find.byKey(const Key('saveButton')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // SaveIncomplete indicates the required (Unit Site Name) field is missing
      expect(find.textContaining('Unit: Site Name'), findsOneWidget);

      logger?.info('Unit failure case finished');
    },
  );
});

// System Testing - 03 (SYS ADD-DATA-03)
//
// Level failure case
//
// Preconditions:
// - The Add Data page fully renders within the loaded state
// - Level required sections (fields) are filled
//
// Postconditions:
// - Errors are properly handled and missing Level fields are shown

group('SYS-ADD-03 - Level Failure Case', () {
  testWidgets(
    'missing Level Unit Name and Parent Name lead to SaveIncomplete and error message',
    (WidgetTester tester) async {
      logger?.info('Running level failure case');

      // Uses the helper to build the Add Data page
      await tester.pumpWidget(wrap(const DashboardAddPage()));
      await tester.pumpAndSettle();

      // Enters valid Site Information fields
      await tester.enterText(
        find.byKey(const Key('Site Information-Name')),
        'DiRx-28',
      );
      await tester.enterText(
        find.byKey(const Key('Site Information-Borden')),
        '1234',
      );
      await tester.enterText(
        find.byKey(const Key('Site Information-Area')),
        'Western End of Slope',
      );

      // Enters only the Unit Name field
      await tester.enterText(
        find.byKey(const Key('Unit-Name')),
        'N84SW1',
      );

      await tester.enterText(
        find.byKey(const Key('Unit-Site Name')),
        'DiRx-28',
      );

      // Enters the "Level" fields only and leaves Unit Name and leaves the other ones empty
      await tester.enterText(
        find.byKey(const Key('Level-Name')),
        'Level 1',
      );
      await tester.enterText(
        find.byKey(const Key('Level-Upper Limit')),
        '2',
      );
      await tester.enterText(
        find.byKey(const Key('Level-Lower Limit')),
        '1',
      );

      // Taps the save button and waits for validation and UI updates to finish (10 seconds)
      await tester.tap(find.byKey(const Key('saveButton')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // SaveIncomplete indicates the required (Level fields) field are missing
      expect(find.textContaining('Level: Unit Name'), findsOneWidget);
      expect(find.textContaining('Level: Parent Name'), findsOneWidget);

      logger?.info('Level failure case finished');
    },
  );
});

//System Testing - 04 (SYS ADD-DATA-04)

//Assemblage failure case

// Preconditions:
// - The Add Data page fully renders within the loaded state
// - Previous required sections are filled
//
// Postconditions:
// - Errors are properly handled and missing Assemblage fields are shown

group('SYS-ADD-04 - Assemblage Failure Case', () {
  testWidgets(
    'missing Assemblage Unit Name and Level Name lead to SaveIncomplete and error message',
    (WidgetTester tester) async {

      logger?.info('Running assemblage failure case');

      //Uses the helper to build the Add Data page
      await tester.pumpWidget(wrap(const DashboardAddPage()));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('Site Information-Name')),
        'DiRx-28',
      );
      await tester.enterText(
        find.byKey(const Key('Site Information-Borden')),
        '1234',
      );
      await tester.enterText(
        find.byKey(const Key('Site Information-Area')),
        'Area A',
      );

      await tester.enterText(
        find.byKey(const Key('Unit-Name')),
        'N84SW1',
      );
      await tester.enterText(
        find.byKey(const Key('Unit-Site Name')),
        'DiRx-28',
      );

      await tester.enterText(
        find.byKey(const Key('Level-Name')),
        'Level 1',
      );
      await tester.enterText(
        find.byKey(const Key('Level-Unit Name')),
        'N84SW1',
      );
      await tester.enterText(
        find.byKey(const Key('Level-Parent Name')),
        'Parent A',
      );
      await tester.enterText(
        find.byKey(const Key('Level-Upper Limit')),
        '2',
      );
      await tester.enterText(
        find.byKey(const Key('Level-Lower Limit')),
        '1',
      );
      await tester.enterText(
        find.byKey(const Key('Assemblage-Assemblage Name')),
        'Level 1 Faunal',
      );

    // Taps the save button and waits for validation and UI updates to finish (10 seconds)  
      await tester.tap(find.byKey(const Key('saveButton')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // SaveIncomplete indicates missing required Assemblage fields (Unit Name and Level Name) and displays validation errors
      expect(find.textContaining('Assemblage: Unit Name'), findsOneWidget);
      expect(find.textContaining('Assemblage: Level Name'), findsOneWidget);

      logger?.info('Assemblage failure case finished');
    },
  );
});

//System Testing - 05 (SYS ADD-DATA-05)

//Artifact failure case

// Preconditions:
// - The Add Data page fully renders within the loaded state
// - Previous required sections are filled
// - The artifact section is being inserted by entering the following fields
//
// Postconditions:
// - Errors are properly handled and missing Artifact fields are shown

}




  



    


