// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';


import 'package:flutter/material.dart';
import 'package:search_cms/main.dart';
import 'package:integration_test/integration_test.dart';

import 'package:http/http.dart' as http;
import 'package:search_cms/core/app_config.dart';
import 'package:search_cms/core/injections.dart';

void main() async {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end-to-end test', () {

    test("Attempt http ping to Supabase", () async {
    await expectLater(await pingSupabase(), true,
    ).timeout(Duration(seconds: 2));

    await Future.delayed(Duration(seconds: 2));

  }, retry: 30);
    testWidgets('Verify access system button exists', (
      tester,
    ) async {
      // Load app widget.
      await tester.pumpWidget(const MyApp());

      // Verify the counter starts at 0.
      expect(find.text('Email'), findsOneWidget);

      // Finds the floating action button to tap on.
      final fab = find.byKey(const ValueKey('accessSystemButton'));

      // Emulate a tap on the floating action button.
      await tester.tap(fab);

      // Trigger a frame.
      await tester.pumpAndSettle();

      // Verify the counter increments by 1.
    });

    testWidgets('Verify login system functions', (
      tester,
    ) async {
      // Load app widget.

      print("Running test");
      await tester.pumpWidget(const MyApp());
      await initInjections();

      // Verify the counter starts at 0.
      expect(find.text('Email'), findsOneWidget);

      // Finds the floating action button to tap on.
      final fab = find.byKey(const ValueKey('accessSystemButton'));

      await tester.enterText((find.byType(TextField).first), 'pleasework@fortheloveofgod.ca');

      await tester.pumpAndSettle();

      await tester.enterText((find.byType(TextField).last), 'passwordypassword');

      await tester.pumpAndSettle();

      await tester.tap(fab);

      // Trigger a frame.

      await tester.pumpAndSettle();

      final finder = find.byKey(Key("toast_successful_login"));

      if (!tester.any(finder)){
        fail("Could not find success toast");
      }
      print("Done running test");

      // Verify the counter increments by 1.
    });


  });

  // END to END Test
  // a test that verifies powersync is up and running
  // Once it's available, i.e. timeout isn't hit 400 seconds
  // Test flutter application (Login button)

  test("Retry connection to supabase", () async {
    await expectLater(await pingSupabase(), true,
    ).timeout(Duration(seconds: 10));

    await Future.delayed(Duration(seconds: 5));

  }, retry: 30);

  // http.get

} 

Future<bool> pingSupabase() async {
  try {
    print("Before response");
    final response = await http.get(Uri.parse('http://127.0.0.1:54321/auth/v1/health'), headers: {'apikey': AppConfig.supabaseAnonKey});
    print("Finished response");
    
    print(response.statusCode);
    if (response.statusCode == 400){
      return false;
    }


  } catch (e) {
    return false;
  }
  return true;
}
