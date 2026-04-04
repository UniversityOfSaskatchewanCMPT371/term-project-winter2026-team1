import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/injections.dart';
import 'package:search_cms/main.dart';

void basicFunctionalityTest(Logger logger) {
  group("Basic Functionality Test", () {
    /*
      Preconditions:
      - Supabase backend must be running and reachable
      - PowerSync service must be running and able to sync local data
      - Database contains user with:
        email: pleasework@fortheloveofgod.ca
        password: passwordypassword
      - The user's role record must exist in the role table and be available
        through PowerSync sync
      - App injections must be initialized before pumping MyApp

      Postconditions:
      - Login completes successfully after auth + PowerSync sync + local role lookup
      - Dashboard/home navigation or other post-login success state is reached
    */
    testWidgets("Login system functions correctly", (tester) async {
      logger.info("Running login system smoke test");

      await initInjections();
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key("emailField")),
        'pleasework@fortheloveofgod.ca',
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key("passwordField")),
        'passwordypassword',
      );
      await tester.pumpAndSettle();

      final fab = find.byKey(const ValueKey('accessSystemButton'));
      expect(fab, findsOneWidget);

      await tester.tap(fab);
      await tester.pump();

      bool success = false;

      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(seconds: 1));

        if (tester.any(find.byKey(const ValueKey('toast_successful_login'))) ||
            tester.any(find.text('Dashboard Home'))) {
          success = true;
          break;
        }
      }

      if (!success) {
        logger.severe("Login did not reach a visible success state");
        fail("Could not observe login success");
      }
    });
  });
}