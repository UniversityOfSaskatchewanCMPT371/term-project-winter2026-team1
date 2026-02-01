import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './app_config.dart';
import './models/faunal_schema.dart';
import './supabase.dart';

final log = Logger('powersync-supabase-faunal');

// Postgres Response codes that we cannot recover from by retrying
final List<RegExp> fatalResponseCodes = [
  // Class 22 — Data Exception
  // Examples include data type mismatch.
  RegExp(r'^22...$'),
  // Class 23 — Integrity Constraint Violation.
  // Examples include NOT NULL, FOREIGN KEY and UNIQUE violations.
  RegExp(r'^23...$'),
  // INSUFFICIENT PRIVILEGE - typically a row-level security violation
  RegExp(r'^42501$'),
];

// Use Supabase for authentication and data upload
class FaunalSupabaseConnector extends PowerSyncBackendConnector {
  Future<void>? _refreshFuture;

  // Get a Supabase token to authenticate against the PowerSync instance
  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    await _refreshFuture;

    // Use Supabase token for PowerSync
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      // Not logged in
      return null;
    }

    // Use the access token to authenticate against PowerSync
    final token = session.accessToken;

    // userId and expiresAt are for debugging purposes only
    final userId = session.user.id;
    final expiresAt = session.expiresAt == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000);

    return PowerSyncCredentials(
      endpoint: AppConfig.powersyncUrl,
      token: token,
      userId: userId,
      expiresAt: expiresAt,
    );
  }

  @override
  void invalidateCredentials() {
    // Trigger a session refresh if auth fails on PowerSync.
    // Generally, sessions should be refreshed automatically by Supabase.
    // However, in some cases it can be a while before the session refresh is
    // retried. We attempt to trigger the refresh as soon as we get an auth
    // failure on PowerSync.
    //
    // This could happen if the device was offline for a while and the session
    // expired, and nothing else attempt to use the session it in the meantime.
    //
    // Timeout the refresh call to avoid waiting for long retries,
    // and ignore any errors. Errors will surface as expired tokens.
    _refreshFuture = Supabase.instance.client.auth
        .refreshSession()
        .timeout(const Duration(seconds: 5))
        .then((response) => null, onError: (error) => null);
  }

  // Upload pending changes to Supabase
  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    // This function is called whenever there is data to upload, whether the
    // device is online or offline.
    // If this call throws an error, it is retried periodically.
    final transaction = await database.getNextCrudTransaction();
    if (transaction == null) {
      return;
    }

    final rest = Supabase.instance.client.rest;
    CrudEntry? lastOp;

    try {
      for (var op in transaction.crud) {
        lastOp = op;

        final table = rest.from(op.table);

        // By default PowerSync uses text IDs locally.
        // The Supabase PK for id is bigint, so coerce to int for 'faunal_data'.
        dynamic idValue = op.id;
        if (op.table == 'faunal_data') {
          if (idValue is String) {
            final parsed = int.tryParse(idValue);
            if (parsed != null) {
              idValue = parsed;
            }
          }
        }

        if (op.op == UpdateType.put) {
          var data = Map<String, dynamic>.of(op.opData ?? {});
          data['id'] = idValue;
          await table.upsert(data);
        } else if (op.op == UpdateType.patch) {
          await table.update(op.opData ?? {}).eq('id', idValue);
        } else if (op.op == UpdateType.delete) {
          await table.delete().eq('id', idValue);
        }
      }

      // All operations successful
      await transaction.complete();
    } on PostgrestException catch (e) {
      if (e.code != null &&
          fatalResponseCodes.any((re) => re.hasMatch(e.code!))) {
        /// Instead of blocking the queue with these errors,
        /// discard the (rest of the) transaction.
        ///
        /// Note that these errors typically indicate a bug in the application.
        /// If protecting against data loss is important, save the failing records
        /// elsewhere instead of discarding, and/or notify the user.
        log.severe('Data upload error - discarding $lastOp', e);
        await transaction.complete();
      } else {
        // Error may be retryable - e.g. network error or temporary server error.
        // Throwing an error here causes this call to be retried after a delay.
        rethrow;
      }
    }
  }
}

bool isLoggedIn() {
  return Supabase.instance.client.auth.currentSession?.accessToken != null;
}

Future<String> getDatabasePath() async {
  const dbFilename = 'faunal.db';
  if (kIsWeb) return dbFilename;
  final dir = await getApplicationSupportDirectory();
  return join(dir.path, dbFilename);
}

const options = SyncOptions(syncImplementation: SyncClientImplementation.rust);

// Open a seperate PowerSync database for faunal_data
Future<PowerSyncDatabase> openFaunalDatabase() async {
  await loadSupabase();

  final db = PowerSyncDatabase(
    schema: faunalSchema, 
    path: await getDatabasePath(),
    logger: attachedLogger,
  );
  await db.initialize();

  var connector = FaunalSupabaseConnector();

  if (isLoggedIn()) {
    db.connect(connector: connector, options: options);
  } else {
    // Anonymous sign-in fine for spike prototype
    await Supabase.instance.client.auth.signInAnonymously();
    db.connect(connector: connector, options: options); 
  }

  // Keep credentials in sync with Supabase auth changes
  Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
    switch (data.event) {
      case AuthChangeEvent.signedIn:
        connector = FaunalSupabaseConnector();
        db.connect(connector: connector, options: options);
        break;
      case AuthChangeEvent.signedOut:
        await db.disconnect();
        break;
      case AuthChangeEvent.tokenRefreshed:
        connector.prefetchCredentials();
        break;
      default:
        break;
    }
  });

  return db;
}


