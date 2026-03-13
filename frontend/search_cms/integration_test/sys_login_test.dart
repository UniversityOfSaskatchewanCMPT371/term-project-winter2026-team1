import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_cms/features/authentication/presentation/pages/login_page.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../test/features/authentication/presentation/pages/login_page_testcases.dart';

import 'package:search_cms/features/authentication/presentation/pages/login_page.dart';
import 'package:search_cms/features/authentication/presentation/bloc/login_page_cubit.dart';
import 'package:search_cms/features/authentication/presentation/bloc/login_page_state.dart';

// Test Credentials for success case
const String _testEmail = String.fromEnvironment('TEST_EMAIL');
const String _testPassword = String.fromEnvironment('TEST_PASSWORD');
const String _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const String _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

// Bad credentials to intentionally fail login
const String _badEmail = 'iamanevildoerandthisismyemail@totallyrealemail.com';
const String _badPassword = 'dorwssap9000';

// Build a copy of the real router for use in this test suite
// Mirrors all the real routes but does not build the actual home page
// This test only goes as far as checking the route of the page is switched to
// '/dashboard/home' and does not test and of the actual rendering of the home page
GoRouter _buildTestRouter() {
return GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/dashboard/home',
      builder: (_, __) => const Scaffold(
        body: Center(child: Text("Dashboard Home"))),
    )
    ],
  );
}

// Wrap the router with a Sizer for LoginPage responsive layouts
Widget wrapWithRouter(GoRouter router) {
  return Sizer(
    builder: (_, __, ___) => MaterialApp.router(
      routerConfig: router,
    )
  )
}

void main() {
  Widget wrap(Widget child) {
    return Sizer(
      builder: (_, __, ___) {
        return MaterialApp(home: child);
      },
    );
  }

  // Runs all widget tests to verify page rendering
  // Also handles cases of invalid inputs to the text entry fiels
  runLoginPageTestCases(() => wrap(const LoginPage()));

  group('Test login system', () {
      
  });
}

//final path = GoRouterState.of(context).uri.path;