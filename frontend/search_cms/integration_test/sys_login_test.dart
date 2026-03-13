import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:search_cms/features/authentication/presentation/bloc/login_cubit.dart';
import 'package:search_cms/features/authentication/presentation/bloc/login_state.dart';
import 'package:search_cms/features/authentication/presentation/pages/login_page.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../test/features/authentication/presentation/pages/login_page_testcases.dart';

// Constant inputs
// Test Credentials for success case
const String _testEmail = String.fromEnvironment('TEST_EMAIL');
const String _testPassword = String.fromEnvironment('TEST_PASSWORD');
const String _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const String _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

// Bad credentials to intentionally fail login
const String _badEmail = 'iamanevildoerandthisismyemail@totallyrealemail.com';
const String _badPassword = 'dorwssap9000';

// Helper functions

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
  );
}

// Helper function that fills out the form fields with provided credentials and submits
Future<void> fillAndSubmit(
  WidgetTester tester, {
    required String email,
    required String password,
  }) async {

    await tester.enterText(find.byKey(const ValueKey('emailField')), email);
    await tester.enterText(find.byKey(const ValueKey('passwordField')), password);
    await tester.tap(find.byKey(const ValueKey('accessSystemButton')));
    // Extend settle timeout to account for real network latency
    await tester.pumpAndSettle(const Duration(seconds: 10));
  }

// Start test

void main() {

  setUpAll(() async {
    // Initialize Supabase for the test suite
    try {
      await Supabase.initialize(
        url: _supabaseUrl,
        anonKey: _supabaseAnonKey);
    } catch (_) {
      // Supabase is already initialized so we can move on
      // TODO verify this behaviour with Theo
    }
  });

  tearDown(() async {
    // Sign out after each test for a clean authentication slate
    await Supabase.instance.client.auth.signOut();
  });


  // Runs all widget tests to verify page rendering
  // Also handles cases of invalid inputs to the text entry fiels
  Widget wrap(Widget child) {
    return Sizer(
      builder: (_, __, ___) {
        return MaterialApp(home: child);
      },
    );
  }
  runLoginPageTestCases(() => wrap(const LoginPage()));

  // System tests

  // Failure case
  group('Login Failure Case', () {
      testWidgets(
        'backend rejects login leading to LoginFailure state, verify error and reset to LoginInitial',
      (WidgetTester tester) async {
        final router = _buildTestRouter();
        await tester.pumpWidget(wrapWithRouter(router));
        await tester.pumpAndSettle();

        // Submit rejected credentials
        await fillAndSubmit(tester, email: _badEmail, password: _badPassword);

        // Get LoginPage cubit from widget tree
        final cubit = tester.element(find.byType(LoginPage)).read<LoginCubit>();
        // Assert that state is an error
        expect(cubit.state, isA<LoginFailure>());
       
        // Assert error message from Supabase is rendered in the snackbar
        final failureState = cubit.state as LoginFailure;
        expect(find.text(failureState.message), findsOneWidget);
 
        // Trigger reset
        cubit.reset();
        await tester.pumpAndSettle();
 
        // Assert state returned to LoginInitial, error no longer visible
        expect(cubit.state, isA<LoginInitial>());
        expect(find.text(failureState.message), findsNothing);
       });
  });

  // Success case
  group('Login Success Case', () {
    testWidgets(
      'backend accepts valid credentials, LoginSuccces with toast shown, route to home page',
      (WidgetTester tester) async {

        // Ensure fields were filled from CI
        assert(
          _testEmail.isNotEmpty && _testPassword.isNotEmpty,
          'TEST_EMAIL and TEST_PASSWORD must be provided via --dart-define. '
        );

        final router = _buildTestRouter();
        await tester.pumpWidget(wrapWithRouter(router));
        await tester.pumpAndSettle();

        // Submit form with valid entries
        await fillAndSubmit(tester, email: _testEmail, password: _testPassword);

        // Assert success toast was shown by the BlocConsumer listener
        expect(
          find.byKey(const ValueKey('toast_successful_login')),
          findsOneWidget,
        );
 
        // Assert: router navigated to dashboard — LoginPage is gone
        expect(find.text('Dashboard Home'), findsOneWidget);
        expect(find.byType(LoginPage), findsNothing);
      });
  });
}

//final path = GoRouterState.of(context).uri.path;