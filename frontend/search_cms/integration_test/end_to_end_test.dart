import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/app_config.dart';
import 'package:search_cms/core/injections.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/main.dart';

/*
  Purpose:
  - Integration test suite for authentication flow and backend connectivity.
  - Validates end-to-end application behavior from service readiness to
    login screen rendering and successful login completion.

  What is specifically covered:
  - Supabase backend health
  - UI rendering of login screen controls
  - Successful credential submission
  - Completion of the async login path that now includes PowerSync sync
    and local role resolution

  Environment assumptions:
  - Local Supabase instance is running
  - Local PowerSync instance is running
  - App injections can initialize successfully
  - A valid test user exists and has a role record available through sync
*/
void main() async {
  final Logger? logger =
  logLevel != Level.OFF ? Logger('Authentication Sign In API') : null;

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end-integration test', () {
    /*
      Preconditions:
      - Supabase local services must be starting or already running

      Postconditions:
      - Health endpoint eventually responds successfully
      - Test suite can continue with auth-dependent checks
    */
    test("Attempt http ping to Supabase", () async {
      logger?.info("Attempting to ping Supabase");

      int attempts = 0;
      const int maxAttempts = 100;
      bool ready = false;

      while (!ready && attempts < maxAttempts) {
        ready = await pingSupabase();
        logger?.info("Ping result: $ready");
        if (!ready) {
          attempts++;
          logger?.info("""Supabase not ready retrying in
          5 seconds ($attempts/$maxAttempts)""");
          await Future<void>.delayed(const Duration(seconds: 5));
        }
      }

      // ** this works as an assertion
      // if result != true this will throw a timeout which will cause retry
      expect(ready, true, reason: "Could not ping Supabase");
    }, timeout: const Timeout(Duration(minutes: 15)));

    /*
      Preconditions:
      - Dependency injections must initialize before MyApp is pumped

      Postconditions:
      - Login page renders correctly
      - Access system button exists and is tappable
    */
    testWidgets('Verify access system button exists', (tester) async {
      logger?.info("Running access system button existence test");

      await initInjections();
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // ** this works as an assertion
      expect(find.text('Email'), findsOneWidget);

      // Finds the floating action button to tap on
      final fab = find.byKey(const ValueKey('accessSystemButton'));

      logger?.info("Looking for access system button");

      // ** this works as an assertion
      expect(fab, findsOneWidget);

      logger?.info("Tapping access system button");
      // Emulate a tap on the floating action button
      await tester.tap(fab);

      // Trigger a frame
      await tester.pumpAndSettle();

      logger?.info("Done running test");
    });

    /*
      Preconditions:
      - Supabase auth must be available
      - PowerSync must be configured and able to complete first sync
      - Valid test credentials must exist
      - User role row must be available via synced local data
      - Dependency injections must initialize before app startup

      Flow under test:
      - Render login page
      - Enter valid credentials
      - Submit login
      - Wait for asynchronous auth, sync, and local role fetch

      Postconditions:
      - Success toast with key "toast_successful_login" appears
      - This indicates the application reached post-login success state
        after PowerSync-backed role retrieval
    */
    testWidgets('Verify login system functions', (tester) async {
      logger?.info("Running login system integration test");

      await initInjections();
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // ** this works as an assertion
      expect(find.text('Email'), findsOneWidget);

      logger?.info("Entering email");
      await tester.enterText(
        find.byKey(const Key("emailField")),
        'pleasework@fortheloveofgod.ca',
      );
      await tester.pumpAndSettle();

      logger?.info("Entering password");
      await tester.enterText(
        find.byKey(const Key("passwordField")),
        'passwordypassword',
      );
      await tester.pumpAndSettle();

      final fab = find.byKey(const ValueKey('accessSystemButton'));
      expect(fab, findsOneWidget);

      logger?.info("Tapping login button");

      await tester.tap(fab);
      await tester.pump();

      bool foundSuccess = false;
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(seconds: 1));

        if (tester.any(find.byKey(const ValueKey('toast_successful_login'))) ||
            tester.any(find.text('Dashboard Home'))) {
          foundSuccess = true;
          break;
        }
      }

      if (!foundSuccess) {
        logger?.severe(
          "Login failed; neither success toast nor dashboard route appeared",
        );
        fail("Could not observe login success");
      }

      logger?.info("Done running test");
    });
  });

  /*
    Purpose:
    - Retry Supabase connectivity in a shorter repeated form to reduce
      transient startup flakiness during local runs.
  */
  test("Retry connection to supabase", () async {
    await expectLater(await pingSupabase(), true)
        .timeout(const Duration(seconds: 10));

    await Future<void>.delayed(const Duration(seconds: 5));
  }, retry: 30);
}

/*
Helper function to ping the Supabase health endpoint

Preconditions:
- Supabase health endpoint must be reachable: 127.0.0.1:54321
- Authentication service must expose endpoint: /auth/v1/health
- AppConfig.supabaseAnonKey contains valid API key

Postconditions:
- Returns true if Supabase responds and is ready
- Returns false if:
    service is not ready,
    request fails due to network or server error,
    exception occurs during HTTP request
*/
Future<bool> pingSupabase() async {
  final Logger logger = Logger('PingSupabase');

  try {
    logger.info("Sending ping to Supabase");
    final response = await http.get(
      Uri.parse('http://127.0.0.1:54321/auth/v1/health'),
      headers: {'apikey': AppConfig.supabaseAnonKey},
    );
    logger.info("Finished response: ${response.statusCode}");

    if (response.statusCode == 400) {
      logger.warning("Supabase is not ready yet");
      return false;
    }
  } catch (e) {
    logger.severe("Error pinging Supabase: $e");
    return false;
  }
  return true;
}