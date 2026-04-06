import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/injections.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/presentation/bloc/add_data_cubit.dart';
import 'package:search_cms/features/dashboard/presentation/bloc/add_data_state.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_add_page.dart';
import 'package:sizer/sizer.dart';

// Helper functions

// Build a copy of the real router for use in this test suite
// This test only checks the add data page flow is switched to

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
        builder: (_, __) => const Scaffold(
          body: Center(child: Text('Dashboard Home')),
        ),
      ),
    ],
  );
}

// Wrap the router with a Sizer for AddDataPage responsive layouts
Widget wrapWithRouter(GoRouter router) {
  return Sizer(
    builder: (_, __, ___) => MaterialApp.router(
      routerConfig: router,
    ),
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
}

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
        await tester.pumpAndSettle(const Duration(seconds: 10));


        // Gets the Add Data Page from the widget tree
        final cubit = tester
            .element(find.byType(BlocConsumer<AddDataCubit, AddDataState>))
            .read<AddDataCubit>();

        // SaveIncomplete indicates missing required Site Information fields (Borden and Area) and displays validation errors
        expect(cubit.state, isA<SaveIncomplete>());
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
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Gets the Add Data cubit from the widget tree
      final cubit = tester
          .element(find.byType(BlocConsumer<AddDataCubit, AddDataState>))
          .read<AddDataCubit>();

      // SaveIncomplete indicates the required (Unit Site Name) field is missing
      expect(cubit.state, isA<SaveIncomplete>());
      expect(find.textContaining('Unit: Site Name'), findsOneWidget);

      logger?.info('Unit failure case finished');
    },
  );
});


  



    


