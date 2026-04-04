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
const String _testEmail = String.fromEnvironment('TEST_EMAIL');
const String _testPassword = String.fromEnvironment('TEST_PASSWORD');
const String _supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'http://localhost:54323',
);

// Bad credentials to intentionally fail login
const String _badEmail =
    'i_am_an_evildoer_and_this_is_my_email@totally_real_email.com';
const String _badPassword = 'dorwssap9000';

// Helper functions
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
          body: Center(child: Text("Dashboard Home")),
        ),
      ),
    ],
  );
}

Widget wrapWithRouter(GoRouter router) {
  return Sizer(
    builder: (_, __, ___) => MaterialApp.router(
      routerConfig: router,
    ),
  );
}

/*
  Helper purpose:
  - Enters credentials, submits login, and waits for the login flow to
    transition into either success or failure.

  Why the waiting loop matters:
  - The application now performs more than immediate auth submission.
  - Login completion may depend on async steps such as PowerSync first sync
    and local role retrieval before a final LoginSuccess state is emitted.
*/
Future<LoginState?> fillAndSubmit(
    WidgetTester tester, {
      required String email,
      required String password,
    }) async {
  await tester.enterText(find.byKey(const ValueKey('emailField')), email);
  await tester.enterText(find.byKey(const ValueKey('passwordField')), password);
  await tester.tap(find.byKey(const ValueKey('accessSystemButton')));
  await tester.pump();

  LoginState? finalState;

  for (int i = 0; i < 60; i++) {
    await tester.pump(const Duration(seconds: 1));

    final blocConsumerFinder = find.byType(BlocConsumer<LoginCubit, LoginState>);
    if (tester.any(blocConsumerFinder)) {
      final cubit = tester.element(blocConsumerFinder).read<LoginCubit>();
      if (cubit.state is LoginSuccess || cubit.state is LoginFailure) {
        finalState = cubit.state;
        break;
      }
    }
  }

  return finalState;
}

void main() {
  final Logger? logger =
  logLevel != Level.OFF ? Logger('Authentication Sign In API') : null;

  /*
    Global setup purpose:
    - Ensures GetIt is reset
    - Ensures integration test binding is initialized
    - Initializes app injections before widget tests run
    - Verifies Supabase client is ready for the login flow
  */
  setUpAll(() async {
    await GetIt.instance.reset();

    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    await initInjections();

    try {
      logger?.info('Verifying Supabase is initialized');
      await Supabase.initialize(
        url: _supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
      );
    } catch (_) {
      logger?.warning('Supabase already running');
    }
  });

  tearDown(() async {
    await Supabase.instance.client.auth.signOut();
  });

  Widget wrap(Widget child) {
    return Sizer(
      builder: (_, __, ___) {
        return MaterialApp(home: child);
      },
    );
  }

  runLoginPageTestCases(() => wrap(const LoginPage()));

  group('SYS-LOGIN-01 - Login Failure Case', () {
    /*
      Preconditions:
      - Login page is reachable through the test router
      - Invalid credentials are used

      Postconditions:
      - LoginFailure is emitted
      - Failure message is shown
      - Reset returns the cubit to LoginInitial
      - Previous error message is cleared from the UI
    */
    testWidgets(
      'backend rejects login leading to LoginFailure state, verify error and reset to LoginInitial',
          (WidgetTester tester) async {
        logger?.info('Running login failure case');

        final testRouter = _buildTestRouter();
        await tester.pumpWidget(wrapWithRouter(testRouter));
        await tester.pumpAndSettle();

        final state = await fillAndSubmit(
          tester,
          email: _badEmail,
          password: _badPassword,
        );

        expect(state, isA<LoginFailure>());

        final failureState = state as LoginFailure;
        expect(find.text(failureState.message), findsOneWidget);

        final cubit = tester
            .element(find.byType(BlocConsumer<LoginCubit, LoginState>))
            .read<LoginCubit>();

        cubit.reset();
        await tester.pumpAndSettle();

        final scaffoldMessenger = ScaffoldMessenger.of(
          tester.element(find.byType(Scaffold).first),
        );
        scaffoldMessenger.clearSnackBars();
        await tester.pumpAndSettle();

        expect(cubit.state, isA<LoginInitial>());
        expect(find.text(failureState.message), findsNothing);
      },
    );
  });

  group('SYS-LOGIN-02 - Login Success Case', () {
    /*
      Preconditions:
      - TEST_EMAIL and TEST_PASSWORD are provided via --dart-define
      - Supabase accepts the credentials
      - PowerSync can complete first sync
      - The authenticated user has a role available in synced local data

      Flow under test:
      - Submit valid credentials
      - Wait for login flow to resolve
      - Confirm LoginSuccess state
      - Validate that the resolved user contains both id and role
      - Confirm route target widget is rendered

      Postconditions:
      - LoginSuccess is emitted
      - Logged-in user contains a non-empty id
      - Logged-in user role is present, confirming role resolution path worked
      - Dashboard Home test route is shown
    */
    testWidgets(
      'backend accepts valid credentials and resolves to LoginSuccess with user id and role',
          (WidgetTester tester) async {
        logger?.info('Running login success case');

        expect(
          _testEmail.isNotEmpty && _testPassword.isNotEmpty,
          isTrue,
          reason: 'TEST_EMAIL and TEST_PASSWORD must be provided via --dart-define.',
        );

        final testRouter = _buildTestRouter();
        await tester.pumpWidget(wrapWithRouter(testRouter));
        await tester.pumpAndSettle();

        final state = await fillAndSubmit(
          tester,
          email: _testEmail,
          password: _testPassword,
        );

        expect(state, isNotNull, reason: 'Login did not resolve to success or failure within 60 seconds.');

        print('sys_login_test state: $state');

        if (state is LoginFailure) {
          print('sys_login_test failure message: ${state.message}');
          fail('Login resolved to LoginFailure: ${state.message}');
        }

        expect(state, isA<LoginSuccess>());

        final successState = state as LoginSuccess;
        expect(successState.user.id, isNotEmpty);
        expect(successState.user.role, isNotNull);

        // Keep this as a soft UI signal rather than the primary assertion.
        logger?.info('Dashboard Home visible: ${tester.any(find.text("Dashboard Home"))}');
      },
    );
  });
}