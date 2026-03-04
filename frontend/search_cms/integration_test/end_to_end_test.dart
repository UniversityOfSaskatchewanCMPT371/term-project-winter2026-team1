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
- Integration test suite for authentication system and backend connectivity
- Validates end-to-end workflow of the application, backend availability, 
    UI rendering, successful user login
- Operates against running local supabase instance
*/
void main() async {

  final Logger? logger = 
    logLevel != Level.OFF ? Logger('Authentication Sign In API') : null;

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end-to-end-integration test', () {

    /*
    Preconditions:
    - Supabase instance must be running locally
    - Supabase health endpoint must be reachable: 127.0.0.1:54321

    Postconditions:
    - Confirms backend authentication system is up and running
    */
    test("Attempt http ping to Supabase", (
    ) async {
      logger?.info("Attempting to ping Supabase");

      final result = await pingSupabase();
      logger?.info("Ping result: $result");

      // ** this works as an assertion
      // if result != true this will throw a timeout which will cause retry
      await expectLater(result, true,
      ).timeout(Duration(seconds: 2));

      await Future<void>.delayed(Duration(seconds: 2));
  }, retry: 30);

    /*
    Preconditions:
    - MyApp widget must load successfully
    - LoginPage must render with correct fields

    Postconditions:
    - Button exists and is tappable
    */
    testWidgets('Verify access system button exists', (
      tester,
    ) async {
      logger?.info("Running access system button existence test");
      // Load app widget
      await tester.pumpWidget(const MyApp());

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
    - Supabase backend must be running
    - Database contains user with:
      email: pleasework@fortheloveofgod.ca
      password: passwordypassword
    - public.role table exists

    Postconditions:
    - SnackBar with key "toast_successful_login" is appears
    - Authentication system is verified to be working end to end
    */
    testWidgets('Verify login system functions', (
      tester,
    ) async {
      // Load app widget
      logger?.info("Running login system integration test");
      
      await tester.pumpWidget(const MyApp());

      await initInjections();

      // ** this works as an assertion
      expect(find.text('Email'), findsOneWidget);

      logger?.info("Entering email");
      await tester.enterText(
        (find.byKey(Key("emailField"))), 'pleasework@fortheloveofgod.ca');

      await tester.pumpAndSettle();

      logger?.info("Entering password");
      await tester.enterText(
        (find.byKey(Key("passwordField"))), 'passwordypassword');

      await tester.pumpAndSettle();

      // Finds the floating action button to tap on
      final fab = find.byKey(const ValueKey('accessSystemButton'));
      // ** this works as an assertion
      expect(fab, findsOneWidget);

      logger?.info("Tapping login button");

      await tester.tap(fab);

      // Trigger a frame
      await tester.pumpAndSettle();

      // Finds the succesful login toast
      final finder = find.byKey(Key("toast_successful_login"));
      logger?.finest(finder);

      if (!tester.any(finder)){
        logger?.severe("Login failed; possible backend issue");
        fail("Could not find success toast");
      }

      logger?.info("Done running test");
    });
  });

  // END to END Test
  // a test that verifies powersync is up and running
  // Once it's available, i.e. timeout isn't hit 400 seconds
  // Test flutter application (Login button)

  test("Retry connection to supabase", () async {
    await expectLater(await pingSupabase(), true,
    ).timeout(Duration(seconds: 10));

    await Future<void>.delayed(Duration(seconds: 5));

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
  final Logger? logger = 
    logLevel != Level.OFF ? Logger('PingSupabase') : null;

  try {
    logger?.info("Sending ping to Supabase");
    // Sends get request to local Supabase authentication health endpoint
    // apikey header checks request using the supbase anon key
    final response = await http.get(Uri.parse('http://127.0.0.1:54321/auth/v1/health'), headers: {'apikey': AppConfig.supabaseAnonKey});
    logger?.info("Finished response: ${response.statusCode}");

    if (response.statusCode == 400){
      logger?.warning("Supabase is not ready yet");
      return false;
    }
  } catch (e) {
    logger?.severe("Error pinging Supabase: $e");
    return false;
  }
  return true;
}