import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';

void syncTest(Logger logger) {
  group("Sync Tests", () {
    /*
      Preconditions:
      - Supabase instance must be running
      - Powersync must be initialized
      - Tables must exist in both systems

      Postconditions:
      - Data retrieved from Supabase matches data in Powersync
      - Verifies synchronization between the backend and powersync
    */
    test("Compare Powersync to Supabase", (
    ) async {
      logger.info("Compare Powersync to Supabase");
    });
  });
}