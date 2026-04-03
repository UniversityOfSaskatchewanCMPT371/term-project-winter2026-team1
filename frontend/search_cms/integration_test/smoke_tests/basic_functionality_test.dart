import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/injections.dart';
import 'package:search_cms/main.dart';

void basicFunctionalityTest(Logger logger) {
  group("Basic Functionality Test", () {
    /*
      Purpose:
      - Verifies the login flow works end to end from the login screen UI
        through Supabase authentication and subsequent PowerSync-backed role
        resolution.

      Preconditions:
      - Supabase backend must be running and reachable
      - PowerSync service must be running and able to sync local data
      - Database contains user with:
          email: pleasework@fortheloveofgod.ca
          password: passwordypassword
      - The user's role record must exist in the role table and be available
        through PowerSync local sync
      - App injections must be initialized before pumping MyApp

      Flow under test:
      - Render login screen
      - Enter valid credentials
      - Tap the access system button
      - Wait for async auth + first sync + local role fetch to complete

      Postconditions:
      - SnackBar with key "toast_successful_login" appears
      - This indicates login completed successfully after PowerSync-backed
        role lookup, not merely after credential submission
    */
    testWidgets("Login system functions correctly", (tester) async {
      logger.info("Running login system smoke test");

      await initInjections();
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // ** this works as an assertion
      expect(find.text('Email'), findsOneWidget);

      logger.info("Entering email");
      await tester.enterText(
        find.byKey(const Key("emailField")),
        'pleasework@fortheloveofgod.ca',
      );
      await tester.pumpAndSettle();

      logger.info("Entering password");
      await tester.enterText(
        find.byKey(const Key("passwordField")),
        'passwordypassword',
      );
      await tester.pumpAndSettle();

      // Finds the floating action button to tap on
      final fab = find.byKey(const ValueKey('accessSystemButton'));
      // ** this works as an assertion
      expect(fab, findsOneWidget);

      logger.info("Tapping login button");

      await tester.tap(fab);
      await tester.pump();

      // Finds the succesful login toast
      final finder = find.byKey(const Key("toast_successful_login"));

      bool foundSuccess = false;
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(seconds: 1));
        if (tester.any(finder)) {
          foundSuccess = true;
          break;
        }
      }

      if (!foundSuccess) {
        logger.severe(
          "Login failed; success toast not found after waiting for auth + PowerSync sync",
        );
        fail("Could not find success toast");
      }

      logger.info("Done running test");
    });
  });
}