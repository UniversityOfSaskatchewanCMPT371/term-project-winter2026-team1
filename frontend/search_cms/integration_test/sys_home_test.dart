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
