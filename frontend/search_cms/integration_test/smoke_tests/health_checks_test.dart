import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/app_config.dart';
import 'package:search_cms/core/utils/constants.dart';

void healthChecksTest(Logger logger) {
  group("Health Checks", () {
    /*
      Preconditions:
      - Supabase instance must be running locally
      - Supabase health endpoint must be reachable: 127.0.0.1:54321

      Postconditions:
      - Confirms backend authentication system is up and running
    */
    test("Attempt http ping to Supabase", (
    ) async {
      logger.info("Attempting to ping Supabase");

      int attempts = 0;
      const int maxAttempts = 100;
      bool ready = false;
      while (!ready && attempts < maxAttempts){
        ready = await pingSupabase();
        logger.info("Ping result: $ready");
        if (ready == false){
          attempts ++;
          logger.info("""Supabase not ready retrying in
          5 seconds ($attempts/$maxAttempts)""");
          await Future<void>.delayed(const Duration(seconds: 5));
        }
      }

      // ** this works as an assertion
      // if result != true this will throw a timeout which will cause retry
      expect(ready, true, reason:"Could not ping Supabase");

    }, timeout: const Timeout(Duration(minutes: 15)));

    /*
      Preconditions:
      - Powersync database must be initialized and instance accessible with getIt

      Postconditions:
      - Confirms Powersync service is running without errors
    */
    test("Attempt ping to Powersync", (
    ) async {
      logger.info("Attempting to ping Powersync");

      int attempts = 0;
      const int maxAttempts = 100;
      bool ready = false;

      while (!ready && attempts < maxAttempts) {
        ready = await pingPowersync();
        logger.info("Powersync ping result: $ready");

        if (!ready) {
          attempts++;
          logger.info("""Powersync not ready retrying in
          5 seconds ($attempts/$maxAttempts)""");

          await Future<void>.delayed(const Duration(seconds: 5));
        }
      }
      // ** this works as an assertion
      expect(ready, true, reason: "Powersync is not ready");
      
    }, timeout: const Timeout(Duration(minutes: 15)));

    /*
      Preconditions:
      - Supabase instance must be running locally

      Postconditions:
      - Confirms retry mechanism successfully reconnects to Supabase
    */
    test("Retry connection to Supabase", (
    ) async {
      await expectLater(await pingSupabase(), true,
      ).timeout(Duration(seconds: 10));

      await Future<void>.delayed(Duration(seconds: 5));

    }, retry: 30);
  });
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
    // Sends get request to local Supabase authentication health endpoint
    // apikey header checks request using the supbase anon key
    final response = await http.get(Uri.parse('http://127.0.0.1:54321/auth/v1/health'), headers: {'apikey': AppConfig.supabaseAnonKey});
    logger.info("Finished response: ${response.statusCode}");

    if (response.statusCode == 400){
      logger.warning("Supabase is not ready yet");
      return false;
    }
  } catch (e) {
    logger.severe("Error pinging Supabase: $e");
    return false;
  }
  return true;
}

/*
  Helper function that checks Powersync status

  Preconditions:
  - PowerSyncDatabase is initialized and accessible with getIt

  Postconditions:
  - Returns true if Powersync has no errors
  - Returns false if:
      Powersync is not ready,
      any error exists
*/
Future<bool> pingPowersync() async {
  final Logger logger = Logger('PingPowersync');

  try {
    logger.info("Checking Powersync database");

    final powersync = getIt<PowerSyncDatabase>();

    logger.info("Powersync status: ${powersync.currentStatus}");
    
    if (powersync.currentStatus.anyError != null) {
      logger.warning("Powersync has error: ${powersync.currentStatus.anyError}");
      return false;
    }

    logger.info("Powersync is healthy");
    return true;

  } catch (e) {
    logger.severe("Error checking Powersync: $e");
    return false;
  }
}