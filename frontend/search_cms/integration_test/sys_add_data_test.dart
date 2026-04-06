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

/*

    


