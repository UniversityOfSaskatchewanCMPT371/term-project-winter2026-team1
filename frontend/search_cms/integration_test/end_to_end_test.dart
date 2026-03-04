import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/app_config.dart';
import 'package:search_cms/core/injections.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/main.dart';

void main() async {

  final Logger? logger = 
    logLevel != Level.OFF ? Logger('Authentication Sign In API') : null;

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end-to-end-integration test', () {

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

Future<bool> pingSupabase() async {
  final Logger? logger = 
    logLevel != Level.OFF ? Logger('PingSupabase') : null;

  try {
    logger?.info("Sending ping to Supabase");
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