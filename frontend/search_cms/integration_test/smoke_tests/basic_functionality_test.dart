import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/injections.dart';
import 'package:search_cms/main.dart';

const String _testEmail = String.fromEnvironment('TEST_EMAIL');
const String _testPassword = String.fromEnvironment('TEST_PASSWORD');

bool _isLoginScreenStillVisible(WidgetTester tester) {
  return tester.any(find.byKey(const Key('emailField'))) &&
      tester.any(find.byKey(const Key('passwordField'))) &&
      tester.any(find.byKey(const ValueKey('accessSystemButton')));
}

void basicFunctionalityTest(Logger logger) {
  group("Basic Functionality Test", () {
    /*
      Preconditions:
      - Supabase backend must be running and reachable
      - PowerSync service must be running and able to sync local data
      - TEST_EMAIL and TEST_PASSWORD must be provided via --dart-define
      - The authenticated user must have a role available in synced local data
      - App injections must be initialized before pumping MyApp

      Postconditions:
      - Login completes successfully after auth + PowerSync sync + local role lookup
      - A visible post-login signal is reached, such as:
          * success toast appears, or
          * login screen is no longer visible
    */
    testWidgets("Login system functions correctly", (tester) async {
      logger.info("Running login system smoke test");

      expect(
        _testEmail.isNotEmpty && _testPassword.isNotEmpty,
        isTrue,
        reason: 'TEST_EMAIL and TEST_PASSWORD must be provided via --dart-define.',
      );

      await initInjections();
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key("emailField")),
        _testEmail,
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key("passwordField")),
        _testPassword,
      );
      await tester.pumpAndSettle();

      final fab = find.byKey(const ValueKey('accessSystemButton'));
      expect(fab, findsOneWidget);

      await tester.tap(fab);
      await tester.pump();

      bool success = false;
      bool sawToast = false;
      bool loginScreenGone = false;

      for (int i = 0; i < 60; i++) {
        await tester.pump(const Duration(seconds: 1));

        sawToast = tester.any(find.byKey(const ValueKey('toast_successful_login')));
        loginScreenGone = !_isLoginScreenStillVisible(tester);

        if (sawToast || loginScreenGone) {
          success = true;
          break;
        }
      }

      expect(
        success,
        isTrue,
        reason: 'Could not observe login success. sawToast=$sawToast, loginScreenGone=$loginScreenGone',
      );
    });
  });
}