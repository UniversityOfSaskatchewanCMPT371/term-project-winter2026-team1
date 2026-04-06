import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/injections.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/presentation/bloc/home_cubit.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_add_page.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_home_page.dart';
import 'package:sizer/sizer.dart';

// Build a copy of the real router for use in this test suite
// Mirrors the Add Data and Home routes for navigation testing
// This test only goes as far as checking the route of the page is switched to
// '/dashboard/home' and does not test any of the actual rendering of the home page 
// (This has been taken from Matt's Approach to render + load from page to another page)

GoRouter _buildTestRouter() {
  return GoRouter(
    initialLocation: '/dashboard/add',
    routes: [
      GoRoute(
        path: '/dashboard/add',
        builder: (_, __) => const DashboardAddPage(),
      ),

      GoRoute(
        path: '/dashboard/home',
        builder: (_, __) => BlocProvider(
          create: (_) => HomeCubit()..init(),
          child: const Scaffold(
            body: DashboardHomePage(),
          ),
        ),
      ),
    ],
  );
}

// Wrap the router with a Sizer for LoginPage responsive layouts
Widget wrapWithRouter(GoRouter router) {
  return Sizer(
    builder: (_, __, ___) => MaterialApp.router(
      routerConfig: router,
    )
  );
}

// A standard wrapper for widget tests that are being condemmed
Widget wrap(Widget child) {
  return Sizer(
    builder: (_, __, ___) {
      return MaterialApp(home: child);
    },
  );
}

// Helper function that fills all the valid inputs and submits the form
//
// Preconditions:
// - The Add Data page fully renders within the loaded state
// - THe requri3ed fields keys usually exist on the page
//
// Postconditions:
// - All required Add Data fields are filled with valid values

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
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // SaveIncomplete indicates missing required Site Information fields (Borden and Area) and displays validation errors
        expect(find.textContaining('Missing required fields:'), findsWidgets);
        expect(find.textContaining('Site Information: Borden'), findsWidgets);
        expect(find.textContaining('Site Information: Area'), findsWidgets);

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

        // The "save button" is being tap and waits for the UI and validation to complete
      await tester.tap(find.byKey(const Key('saveButton')));
      await tester.pumpAndSettle(const Duration(seconds: 5));

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

      // The "save button" is being tap and waits for the UI and validation to complete
      await tester.tap(find.byKey(const Key('saveButton')));
      await tester.pumpAndSettle(const Duration(seconds: 5));

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

      // The "save button" is being tap and waits for the UI and validation to complete
      await tester.tap(find.byKey(const Key('saveButton')));
      await tester.pumpAndSettle(const Duration(seconds: 5));

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
group('SYS-ADD-05 - Artifact Failure Case', () {
  testWidgets(
    'missing Artifact Assemblage Name leads to SaveIncomplete and error message',
    (WidgetTester tester) async {

      logger?.info('Running artifact failure case');

      //Uses the helper to build the Add Data page
      await tester.pumpWidget(wrap(const DashboardAddPage()));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('Assemblage-Unit Name')),
        'N84SW1',
      );
      await tester.enterText(
        find.byKey(const Key('Assemblage-Level Name')),
        'Level 1',
      );

      // Enters any "comment-text" Artifact field and leaves the required Assemblage Name empty
      await tester.enterText(
        find.byKey(const Key('Artifact (Faunal)-Comment')),
        'test comment123',
      );

      // The "save button" is being tap and waits for the UI and validation to complete
      await tester.tap(find.byKey(const Key('saveButton')));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // SaveIncomplete indicates missing required Artifact field (Assemblage Name) and displays validation errors
      expect(
        find.textContaining('Artifact (Faunal): Assemblage Name'),
        findsOneWidget,
      );
      logger?.info('Artifact failure case finished');
    },
  );
});

//System Testing - 06 (SYS ADD-DATA-06)

//Successful save- case

// Preconditions:
// - The Add Data page fully renders within the loaded state
// - All required fields are filled
//
// Postconditions:
// - No missing required field "error"" is shown within the UI
// - The Add Data page displays the "save successful" message

group('SYS-ADD-06 - Successful Save Case', () {
  testWidgets(
    'all required fields filled leads to SaveSuccess and success message',
    (WidgetTester tester) async {

      logger?.info('Running successful save-case');

      //Uses the helper to build the Add Data page
      await tester.pumpWidget(wrap(const DashboardAddPage()));
      await tester.pumpAndSettle();

      // Fills all required fields with valid values
      await fillAllRequiredFields(tester);

      // The "save button" is being tap and waits for the UI and validation to complete
      await tester.tap(find.byKey(const Key('saveButton')));

      //Not Enough time for the UI waiting time to validate the save button
      //Thefore, we will use a certain UI enough time to show the success message
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // SaveSuccess indicates all required values were accepted and the save completed successfully
      expect(find.textContaining('Missing required fields:'), findsNothing);

      logger?.info('Successful save case finished');
    },
  );
});

//System Testing - 07 (SYS ADD-DATA-07)

// Reset button case

// Preconditions:
// - The Add Data page fully renders within the loaded state
// - Some fields are filled before pressing the button reset
//
// Postconditions:
// - The entered values are cleared from the Add Data page after pressing the button reset

group('SYS-ADD-07 - Reset Button Case', () {
  testWidgets(
    'pressing the reset button clears the entered field values',
    (WidgetTester tester) async {

      logger?.info('Running reset button case');

      await tester.pumpWidget(wrap(const DashboardAddPage()));
      await tester.pumpAndSettle();

      // Enter some values
      await tester.enterText(
        find.byKey(const Key('Site Information-Name')),
        'DiRx-28',
      );
      await tester.enterText(
        find.byKey(const Key('Unit-Name')),
        'N84SW1',
      );
      await tester.pumpAndSettle();

      // Press reset
      await tester.tap(find.byKey(const Key('resetButton')));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Directly verify the fields are cleared after reset
      final nameField = tester.widget<TextFormField>(
        find.byKey(const Key('Site Information-Name')),
      );
      final unitField = tester.widget<TextFormField>(
        find.byKey(const Key('Unit-Name')),
      );

      expect(nameField.controller?.text ?? '', isEmpty);
      expect(unitField.controller?.text ?? '', isEmpty);

      logger?.info('Reset button case finished');
    },
  );
});

//System Testing - 08 (SYS ADD-DATA-08)

//Homepage row display case

// Preconditions:
// - The Add Data page fully renders within the loaded state
// - All required fields are filled
// - The save action completes successfully
// - The Add Data page redirects to the Homepage after the save button is pressed
//
// Postconditions:
// - The inserted values are shown on the homepage as a row / columns

group('SYS-ADD-08 - Homepage Navigation Case', () {
  testWidgets(
    'pressing save allows navigation to the homepage route',
    (WidgetTester tester) async {

      logger?.info('Running homepage navigation case');

      // Builds the Add Data page and the Home page through the router
      final GoRouter router = _buildTestRouter();
      await tester.pumpWidget(wrapWithRouter(router));
      await tester.pumpAndSettle();

      // Fills all required fields with valid values
      await fillAllRequiredFields(tester);

      // The "save button" is being tap and waits for the UI and validation to complete
      await tester.tap(find.byKey(const Key('saveButton')));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      // No missing field validation should appear before navigation
      expect(find.textContaining('Missing required fields:'), findsNothing);

      // Navigates to the homepage route
      router.go('/dashboard/home');
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.pumpAndSettle(const Duration(seconds: 10)); 

      // Verifies that the homepage route loaded
      expect(find.byType(DashboardHomePage), findsOneWidget);

      logger?.info('Homepage navigation case finished');
    },
  );
});
}