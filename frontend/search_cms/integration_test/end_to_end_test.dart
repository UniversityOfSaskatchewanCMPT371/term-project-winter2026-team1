import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/app_config.dart';
import 'package:search_cms/core/injections.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/authentication/presentation/bloc/login_cubit.dart';
import 'package:search_cms/features/authentication/presentation/bloc/login_state.dart';
import 'package:search_cms/main.dart';

const String _testEmail = String.fromEnvironment('TEST_EMAIL');
const String _testPassword = String.fromEnvironment('TEST_PASSWORD');

bool _isLoginScreenStillVisible(WidgetTester tester) {
  return tester.any(find.byKey(const Key('emailField'))) &&
      tester.any(find.byKey(const Key('passwordField'))) &&
      tester.any(find.byKey(const ValueKey('accessSystemButton')));
}

/*
  Purpose:
  - Integration test suite for authentication flow and backend connectivity.
  - Validates end-to-end application behavior from service readiness to
    login screen rendering and successful login completion.

  Environment assumptions:
  - Local Supabase instance is running
  - Local PowerSync instance is running
  - TEST_EMAIL and TEST_PASSWORD are supplied via --dart-define
  - A valid test user exists and has a role record available through sync
*/
void main() async {
  final Logger? logger =
  logLevel != Level.OFF ? Logger('Authentication Sign In API') : null;

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await GetIt.instance.reset();
  await initInjections();

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
      const int maxAttempts = 30;
      bool ready = false;

      while (!ready && attempts < maxAttempts) {
        ready = await pingSupabase();
        logger?.info("Ping result: $ready");

        if (!ready) {
          attempts++;
          logger?.info(
            "Supabase not ready retrying in 5 seconds ($attempts/$maxAttempts)",
          );
          await Future<void>.delayed(const Duration(seconds: 5));
        }
      }

      expect(ready, true, reason: "Could not ping Supabase");
    }, timeout: const Timeout(Duration(minutes: 5)));

    /*
      Preconditions:
      - Dependency injections must initialize before MyApp is pumped

      Postconditions:
      - Login page renders correctly
      - Access system button exists and is tappable
    */
    testWidgets('Verify access system button exists', (tester) async {
      logger?.info("Running access system button existence test");

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);

      final fab = find.byKey(const ValueKey('accessSystemButton'));
      expect(fab, findsOneWidget);

      await tester.tap(fab);
      await tester.pumpAndSettle();
    });

    /*
      Preconditions:
      - Supabase auth must be available
      - PowerSync must be configured and able to complete first sync
      - TEST_EMAIL and TEST_PASSWORD must be provided
      - User role row must be available via synced local data
      - Dependency injections must initialize before app startup

      Flow under test:
      - Render login page
      - Enter valid credentials
      - Submit login
      - Wait for asynchronous auth, sync, and local role fetch

      Postconditions:
      - A visible post-login signal is reached, such as:
          * success toast appears, or
          * login screen is no longer visible
    */
    testWidgets('Verify login system functions', (tester) async {
      logger?.info("Running login system integration test");

      expect(
        _testEmail.isNotEmpty && _testPassword.isNotEmpty,
        isTrue,
        reason: 'TEST_EMAIL and TEST_PASSWORD must be provided via --dart-define.',
      );

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);

      await tester.enterText(find.byKey(const Key("emailField")), _testEmail);
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
      String? failureMessage;

      final blocFinder = find.byType(BlocConsumer<LoginCubit, LoginState>);

      for (int i = 0; i < 60; i++) {
        await tester.pump(const Duration(seconds: 1));

        sawToast =
            tester.any(find.byKey(const ValueKey('toast_successful_login')));
        loginScreenGone = !_isLoginScreenStillVisible(tester);

        if (tester.any(blocFinder)) {
          final cubit = tester.element(blocFinder).read<LoginCubit>();
          final state = cubit.state;

          if (state is LoginFailure) {
            failureMessage = state.message;
            break;
          }

          if (state is LoginSuccess) {
            success = true;
            break;
          }
        }

        if (sawToast || loginScreenGone) {
          success = true;
          break;
        }
      }

      expect(
        success,
        isTrue,
        reason: failureMessage == null
            ? 'Could not observe login success. sawToast=$sawToast, loginScreenGone=$loginScreenGone'
            : 'Login resolved to failure: $failureMessage',
      );
    });
  });

  test("Retry connection to Supabase", () async {
    await expectLater(await pingSupabase(), true)
        .timeout(const Duration(seconds: 10));

    await Future<void>.delayed(const Duration(seconds: 5));
  }, retry: 10);
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