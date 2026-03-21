import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';

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
      logger.info("Login system functions correctly");
    });
  });
}