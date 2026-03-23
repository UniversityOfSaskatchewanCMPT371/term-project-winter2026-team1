import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/main.dart';

void basicFunctionalityTest(Logger logger) {
  group("Basic Functionality Test", () {
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
    testWidgets("Login system functions correctly", (
      tester,
    ) async {
      logger.info("Running login system smoke test");
      // Load app widget
      await tester.pumpWidget(const MyApp());

      // ** this works as an assertion
      expect(find.text('Email'), findsOneWidget);

      logger.info("Entering email");
      await tester.enterText(
        (find.byKey(Key("emailField"))), 'pleasework@fortheloveofgod.ca');

      await tester.pumpAndSettle();

      logger.info("Entering password");
      await tester.enterText(
        (find.byKey(Key("passwordField"))), 'passwordypassword');

      await tester.pumpAndSettle();

      // Finds the floating action button to tap on
      final fab = find.byKey(const ValueKey('accessSystemButton'));
      // ** this works as an assertion
      expect(fab, findsOneWidget);

      logger.info("Tapping login button");

      await tester.tap(fab);

      // Trigger a frame
      await tester.pumpAndSettle();

      // Finds the succesful login toast
      final finder = find.byKey(Key("toast_successful_login"));
      logger.finest(finder);

      if (!tester.any(finder)){
        logger.severe("Login failed; possible backend issue");
        fail("Could not find success toast");
      }

      logger.info("Done running test");
    });
  });
}