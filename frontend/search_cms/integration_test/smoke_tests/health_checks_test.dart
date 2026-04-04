import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/app_config.dart';
import 'package:search_cms/core/utils/constants.dart';

void healthChecksTest(Logger logger) {
  group("Health Checks", () {
    /*
      Purpose:
      - Confirms the external services required by the authentication flow
        are available before broader integration tests are run.

      Services validated:
      - Supabase auth health endpoint
      - PowerSync instance accessibility and absence of immediate hard errors
    */
    test("Attempt http ping to Supabase", () async {
      logger.info("Attempting to ping Supabase");

      int attempts = 0;
      const int maxAttempts = 30;
      bool ready = false;

      while (!ready && attempts < maxAttempts) {
        ready = await pingSupabase();
        logger.info("Ping result: $ready");

        if (!ready) {
          attempts++;
          logger.info(
            "Supabase not ready, retrying in 5 seconds ($attempts/$maxAttempts)",
          );
          await Future<void>.delayed(const Duration(seconds: 5));
        }
      }

      expect(ready, true, reason: "Could not ping Supabase");
    }, timeout: const Timeout(Duration(minutes: 5)));

    /*
      Preconditions:
      - Powersync database must be initialized and instance accessible with getIt

      Postconditions:
      - Confirms Powersync instance is available
      - Confirms there is no immediate sync error state
      - Does not require first sync to finish before login tests start
    */
    test("Attempt ping to Powersync", () async {
      logger.info("Attempting to ping Powersync");

      final ready = await pingPowersync();
      expect(ready, true, reason: "Powersync instance is unavailable or already in an error state");
    }, timeout: const Timeout(Duration(minutes: 1)));

    test("Retry connection to Supabase", () async {
      await expectLater(await pingSupabase(), true)
          .timeout(const Duration(seconds: 10));

      await Future<void>.delayed(const Duration(seconds: 5));
    }, retry: 10);
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

/*
  Helper function to verify PowerSync readiness

  Preconditions:
  - PowerSync instance is registered in GetIt

  Postconditions:
  - Returns true if PowerSync is reachable and not already reporting a hard error
  - Returns false if the instance cannot be accessed or is already in an error state
*/
Future<bool> pingPowersync() async {
  final Logger logger = Logger('PingPowersync');

  try {
    logger.info("Checking Powersync database");

    final powersync = getIt<PowerSyncDatabase>();
    final status = powersync.currentStatus;

    logger.info("Powersync status: $status");

    if (status.anyError != null) {
      logger.warning("Powersync has error: ${status.anyError}");
      return false;
    }

    return true;
  } catch (e) {
    logger.severe("Error checking Powersync: $e");
    return false;
  }
}