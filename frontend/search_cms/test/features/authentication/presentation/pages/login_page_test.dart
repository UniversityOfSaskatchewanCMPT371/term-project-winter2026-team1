/// Widget tests for LoginPage form behavior.
///
/// These tests verify that the login UI renders expected fields and that
/// built-in validation prevents submission when input is invalid.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/authentication/presentation/pages/login_page.dart';
import 'package:sizer/sizer.dart';

void main() {
  Widget _wrap(Widget child) {
    return Sizer(
      builder: (_, __, ___) {
        return MaterialApp(home: child);
      },
    );
  }

  group('LoginPage', () {
    // Verifies the page renders the Email and Password fields and the submit button text.
    testWidgets('LOGIN-PAGE-1-renders email/password fields and submit button', (tester) async {
      await tester.pumpWidget(_wrap(const LoginPage()));

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Access System'), findsOneWidget);
    });

    // Verifies submitting empty form shows validation errors.
    testWidgets('LOGIN-PAGE-2-shows validation errors when fields are empty', (tester) async {
      await tester.pumpWidget(_wrap(const LoginPage()));

      await tester.tap(find.text('Access System'));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    // Verifies invalid email triggers email validation error.
    testWidgets('LOGIN-PAGE-3-shows validation error for invalid email', (tester) async {
      await tester.pumpWidget(_wrap(const LoginPage()));

      await tester.enterText(find.byType(TextFormField).at(0), 'not-an-email');
      await tester.enterText(find.byType(TextFormField).at(1), '123456');

      await tester.tap(find.text('Access System'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    // Verifies short password triggers password length validation error.
    testWidgets('LOGIN-PAGE-4-shows validation error for short password', (tester) async {
      await tester.pumpWidget(_wrap(const LoginPage()));

      await tester.enterText(find.byType(TextFormField).at(0), 'abc@abc.com');
      await tester.enterText(find.byType(TextFormField).at(1), '12345');

      await tester.tap(find.text('Access System'));
      await tester.pumpAndSettle();

      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });
  });
}