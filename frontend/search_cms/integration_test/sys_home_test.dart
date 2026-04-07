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
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_home_page.dart';
import 'package:sizer/sizer.dart';

// Helper functions

// Build a copy of the real router for use in this test suite
// Mirrors the Homepage for navigation testing
// This test only goes as far as checking the route of the page is switched to
// '/dashboard/home' and does not test any of the actual rendering of the home page

// (This has been taken from Matt's Approach to render + load from page to another page)
GoRouter _buildTestRouter() {
  return GoRouter(
    initialLocation: '/dashboard/home',
    routes: [
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

// Wrap the router with a Sizer for DashboardHomePage responsive layouts
Widget wrapWithRouter(GoRouter router) {
  return Sizer(
    builder: (_, __, ___) => MaterialApp.router(
      routerConfig: router,
    ),
  );
}

//Uses a helper for locating the normal basic search input
Finder _findBasicSearchField() {
  return find.byKey(const Key('basicSearchBar'));
}

//Uses helper for locating the normal "search" button 
Finder _findSearchButton() {
  return find.byKey(const Key('searchButton'));
}

//Uses helper for locating toggle buttons
Finder _findSearchToggle() {
  return find.text('Search').first;
}

//Uses the helper to findAdvancedSearchToggle to the Advanced Search
Finder _findAdvancedSearchToggle() {
  return find.text('Advanced Search');
}

// Start test
void main() {

  final Logger? logger = 
    logLevel != Level.OFF ? Logger('Home Page System Test') : null;

    
    setUpAll(() async {
    // Reset GetIt before registering to avoid double registration
    // across each of the test runs
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
      await GetIt.instance.reset();
      await initInjections();
    });

    /*--------- System tests (Homepage) ---------*/

      // System Testing - 01 (SYS HOME-01)
      //
      // Homepage render case
      //
      // Preconditions:
      // - Homepage backend must be running
      // - Homepage properly renders and can fetch the data
      //
      // Postconditions:
      // - Homepage title is shown
      // - Search and Advanced Search toggles are also shown
      // - Basic search field and Search button are shown as well
      group('SYS-HOME-01 - Homepage Render Case', () {
        testWidgets(
           
          'homepage renders search controls and initial data',
          (WidgetTester tester) async {

            logger?.info('Running homepage render case');

            //Uses the helper to build the HomePage
            await tester.pumpWidget(wrapWithRouter(_buildTestRouter()));
            await tester.pumpAndSettle(const Duration(seconds: 5));

            //Indicates the following widgets within the helper function
            expect(find.text('Home'), findsOneWidget);
            expect(_findSearchToggle(), findsOneWidget);
            expect(_findAdvancedSearchToggle(), findsOneWidget);
            expect(_findBasicSearchField(), findsOneWidget);
            expect(_findSearchButton(), findsOneWidget);
          

            logger?.info('Homepage render case finished');
      },
    );
  });


  // System Testing - 02 (SYS HOME-02)
  //
  // Homepage toggle case
  //
  // Preconditions:
  // - The Homepage properly renders
  // - Search toggle buttons are visible and shown
  //
  // Postconditions:
  // - Advanced Search field and selected after pressing Advanced Search
  // - Basic Search field reappears after pressing Search

    group('SYS-HOME-02 - Homepage Toggle Case', () {
    testWidgets(
      'toggle switches between Search and Advanced Search',
      (WidgetTester tester) async {
        logger?.info('Running homepage toggle case');

        await tester.pumpWidget(wrapWithRouter(_buildTestRouter()));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // The Basic Search section appears first 
        expect(_findBasicSearchField(), findsOneWidget);

        // Then the "AdvancedSearch" is selected 
        await tester.tap(_findAdvancedSearchToggle());
        await tester.pumpAndSettle();

        // Advanced Search field should now display within the selected option
        expect(find.text('Advanced Search...'), findsOneWidget);

        // Search section box is being pressed
        await tester.tap(_findSearchToggle());
        await tester.pumpAndSettle();

        // Laterwards, Basic Search section box is being pressed
        expect(_findBasicSearchField(), findsOneWidget);

        logger?.info('Homepage toggle case finished');
      },
    );
  });

  // System Testing - 003 (SYS HOME-003)
  //
  // Homepage search - Success submission
  //
  // Preconditions:
  // - The Homepage has at least one row in the database
  // - The Search field and Search button are both visible to the UI layout
  //
  // Postconditions:
  // - The row should match is represented and the search is also executed
  group('SYS-HOME-03 - Homepage Search Success Case', () {
    testWidgets(
      'search finds a matching row',
      (WidgetTester tester) async {
        logger?.info('Running homepage search success case');

        await tester.pumpWidget(wrapWithRouter(_buildTestRouter()));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // The Homepage loads first with the basic search field visible
        expect(_findBasicSearchField(), findsOneWidget);

        // Then the matching value is entered into the basic search field
        await tester.enterText(_findBasicSearchField(), 'DiRx-28');

        // Search button is being pressed
        await tester.tap(_findSearchButton());
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Laterwards, the matching row should appear in the Homepage table
        expect(find.textContaining('DiRx-28'), findsWidgets);

        logger?.info('Homepage search success case finished');
      },
    );
  });

  // System Testing - 04 (SYS HOME-04)
  //
  // Homepage No result case to the HomePage
  //
  // Preconditions:
  // - Homepage properly renders
  // - Search field and Search button are visible
  // - Search term does not exist in any database row
  //
  // Postconditions:
  // - The search value is entered into the basic search field
  // - The Search button is pressed
  // - No matching database row is shown after the search is being executed
  // - The Homepage displays the "no data in database display message"
  
    group('SYS-HOME-04 - Homepage No result Case', () {
    testWidgets(
      'Search with the incorrect missing value shows the no row in the database message',
      (WidgetTester tester) async {
        logger?.info('Running homepage search success case');

        await tester.pumpWidget(wrapWithRouter(_buildTestRouter()));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // The Homepage loads first with the basic search field visible
        expect(_findBasicSearchField(), findsOneWidget);

        // Then the matching value is entered into the basic search field
        await tester.enterText(_findBasicSearchField(), 'qwerty123456');

        // Search button is being pressed
        await tester.tap(_findSearchButton());
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Laterwards, the matching row should appear in the Homepage table
        expect(find.text('No data in database to display'), findsOneWidget,);

        logger?.info('Homepage no result case finished');
      },
    );
  });
}