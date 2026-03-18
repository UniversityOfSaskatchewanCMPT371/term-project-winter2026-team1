import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/app_config.dart';
import 'package:search_cms/core/injections.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/authentication/presentation/bloc/login_cubit.dart';
import 'package:search_cms/features/authentication/presentation/bloc/login_state.dart';
import 'package:search_cms/features/authentication/presentation/pages/login_page.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../test/features/authentication/presentation/pages/login_page_testcases.dart';

// Constant inputs
// Test Credentials for success case
const String _testEnv = String.fromEnvironment('TEST_SECRET', defaultValue: 'FAIL AHHHHHH');
const String _testEmail = String.fromEnvironment('TEST_EMAIL');
const String _testPassword = String.fromEnvironment('TEST_PASSWORD');
const String _supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:8080');
//const String _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

// Bad credentials to intentionally fail login
const String _badEmail = 'i_am_an_evildoer_and_this_is_my_email@totally_real_email.com';
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

  final Logger? logger = 
    logLevel != Level.OFF ? Logger('Authentication Sign In API') : null;
  logger?.warning(_testEnv);

  setUpAll(() async {

    // Reset GetIt before registering to avoid double registration
    // across each of the test runs
    await GetIt.instance.reset();

    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    await initInjections();
    // Initialize Supabase for the test suite
    try {
      logger?.info('Verifying Supabase is initialized');
      await Supabase.initialize(
        url: _supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey);
    } catch (_) {
      logger?.warning('Supabase already running');
      // Supabase is already initialized so we can move on
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

  /*--------- System tests ---------*/

  // Failure case
  /* Preconditions:
   * Supabase backend must be running
   * 
   * Post conditions:
   * Errors are properly handle and system fails gracefully
   */
  group('Login Failure Case', () {
      testWidgets(
      'backend rejects login leading to LoginFailure state, verify error and reset to LoginInitial',
      (WidgetTester tester) async {

        logger?.info('Running login failure case');

        // Use helpers to build login page
        final router = _buildTestRouter();
        await tester.pumpWidget(wrapWithRouter(router));
        await tester.pumpAndSettle();

        // Submit rejected credentials
        logger?.info('Submitting bad credentials');
        await fillAndSubmit(tester, email: _badEmail, password: _badPassword);

        // Get LoginPage cubit from widget tree
        final cubit = tester.element(find.byType(BlocConsumer<LoginCubit, LoginState>)).read<LoginCubit>();
        // Check current state, should be an error from invalid login
        expect(cubit.state, isA<LoginFailure>());
       
        // Assert error message from backend call is rendered in the snackbar
        final failureState = cubit.state as LoginFailure;
        expect(find.text(failureState.message), findsOneWidget);
 
        // Trigger reset
        cubit.reset();
        await tester.pumpAndSettle();

        // Dismiss the snackbar explicitly before asserting it's gone
        final scaffoldMessenger = ScaffoldMessenger.of(
          tester.element(find.byType(Scaffold).first)
        );
        scaffoldMessenger.clearSnackBars();
        await tester.pumpAndSettle();
 
        // Assert state returned to LoginInitial, error no longer visible
        expect(cubit.state, isA<LoginInitial>());
        expect(find.text(failureState.message), findsNothing);

        logger?.info('Login failure test case finished');
       });
  });

  /*----- Success case ----
   * Requires - Environment variables are properly loaded from pipeline
  */
  group('Login Success Case', () {
    testWidgets(
      'backend accepts valid credentials, LoginSuccces with toast shown, route to home page',
      (WidgetTester tester) async {

        logger?.info('Running login success case');
        // Ensure fields were filled from CI
        assert(
          _testEmail.isNotEmpty && _testPassword.isNotEmpty,
          'TEST_EMAIL and TEST_PASSWORD must be provided via --dart-define. '
        );

        final router = _buildTestRouter();
        await tester.pumpWidget(wrapWithRouter(router));
        await tester.pumpAndSettle();

        // Submit form with valid entries
        logger?.info('submitting good credentials');
        await fillAndSubmit(tester, email: _testEmail, password: _testPassword);

        // Assert success toast was shown by the BlocConsumer listener
        expect(
          find.byKey(const ValueKey('toast_successful_login')),
          findsOneWidget,
        );
 
        // Assert router navigated to dashboard — LoginPage is gone
        expect(
          router.routerDelegate.currentConfiguration.last.matchedLocation,
          '/dashboard/home',
        );
        // expect(find.text('Dashboard Home'), findsOneWidget);
        expect(find.byType(LoginPage), findsNothing);

        logger?.info('Login success test case finished');
      });
  });
}
