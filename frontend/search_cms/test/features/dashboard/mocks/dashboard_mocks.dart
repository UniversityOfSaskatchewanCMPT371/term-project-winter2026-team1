/*
Centralized Mockito mocks used across Dashboard feature tests.

Keeping mocks in one place avoids duplicate @GenerateMocks blocks per test file
and makes build_runner output predictable and easy to regenerate.
To regenerate mocks : dart run build_runner build --delete-conflicting-outputs
*/

import 'package:mockito/annotations.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/features/dashboard/data/data_sources/abstract_dashboard_api.dart';
import 'package:search_cms/features/dashboard/data/data_sources/abstract_get_all_areas_api.dart';
import 'package:search_cms/features/dashboard/data/data_sources/abstract_get_all_levels_api.dart';
import 'package:search_cms/features/dashboard/data/data_sources/abstract_get_all_sites_api.dart';
import 'package:search_cms/features/dashboard/data/data_sources/abstract_get_all_units_api.dart';
import 'package:search_cms/features/dashboard/domain/repositories/abstract_dashboard_repository.dart';
import 'package:search_cms/features/dashboard/domain/repositories/abstract_get_all_areas_repository.dart';
import 'package:search_cms/features/dashboard/domain/repositories/abstract_get_all_levels_repository.dart';
import 'package:search_cms/features/dashboard/domain/repositories/abstract_get_all_sites_repository.dart';
import 'package:search_cms/features/dashboard/domain/repositories/abstract_get_all_units_repository.dart';
import 'package:search_cms/features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_areas_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_levels_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_site_areas_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_sites_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_units_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateMocks([
  AbstractDashboardApi,
  AbstractGetAllAreasApi,
  AbstractGetAllLevelsApi,
  AbstractGetAllSitesApi,
  AbstractGetAllUnitsApi,
  AbstractDashboardRepository,
  AbstractGetAllAreasRepository,
  AbstractGetAllLevelsRepository,
  AbstractGetAllSitesRepository,
  AbstractGetAllUnitsRepository,
  GetAllAreasUseCase,
  GetAllLevelsUseCase,
  GetAllSiteAreasUseCase,
  GetAllSitesUseCase,
  GetAllUnitsUseCase,
  DashboardUsecases,
  PowerSyncDatabase,
  SupabaseClient,
])
void main() {}