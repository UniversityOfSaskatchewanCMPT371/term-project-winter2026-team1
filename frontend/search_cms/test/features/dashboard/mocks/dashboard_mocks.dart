/*
Centralized Mockito mocks used across Dashboard feature tests.

Keeping mocks in one place avoids duplicate @GenerateMocks blocks per test file
and makes build_runner output predictable and easy to regenerate.
To regenerate mocks : dart run build_runner build --delete-conflicting-outputs
*/

import 'package:mockito/annotations.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/features/dashboard/data/data_sources/abstract_dashboard_api.dart';
import 'package:search_cms/features/dashboard/data/data_sources/abstract_get_all_sites_api.dart';
import 'package:search_cms/features/dashboard/domain/repositories/abstract_dashboard_repository.dart';
import 'package:search_cms/features/dashboard/domain/repositories/abstract_get_all_sites_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateMocks([
  AbstractDashboardApi,
  AbstractGetAllSitesApi,
  AbstractDashboardRepository,
  AbstractGetAllSitesRepository,
  PowerSyncDatabase,
  SupabaseClient,
])
void main() {}