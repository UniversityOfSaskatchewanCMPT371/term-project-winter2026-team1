import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:search_cms/core/app_config.dart';
import 'package:search_cms/core/injections.dart';
import 'package:search_cms/main.dart';

void main() async {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end-to-end test', () {

    test("Attempt http ping to Supabase", () async {
    await expectLater(await pingSupabase(), true,
    ).timeout(Duration(seconds: 2));

    await Future.delayed(Duration(seconds: 2));

  }, retry: 30);

    // for each test widget have a comment
    // pre and post
    // does supabase need to be running ...,
    // i am checking for ... so that the test passes
    // Ex) Pre: email exists in database. 
    // Post: Verfication that email and password are correct
    // change print statements to logging
    // look at things that will cause problems in this test (exceptions) 
    // and log around it
    testWidgets('Verify login system functions', (
      tester,
    ) async {
      // Load app widget.

      print("Running test");
      await tester.pumpWidget(const MyApp());
      await initInjections();

      // Verify the counter starts at 0.
      // **this works as an assertion
      expect(find.text('Email'), findsOneWidget);

      // change to find by Key
      await tester.enterText((find.byType(TextField).first), 'pleasework@fortheloveofgod.ca');

      await tester.pumpAndSettle();

      // change to find by Key
      await tester.enterText((find.byType(TextField).last), 'passwordypassword');

      await tester.pumpAndSettle();

      // Trigger a frame.
      final loginButton = find.text('Access System');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      final finder = find.byKey(Key("toast_successful_login"));
      // print (finder) = finer

      if (!tester.any(finder)){
        fail("Could not find success toast");
      }
      // change to info
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