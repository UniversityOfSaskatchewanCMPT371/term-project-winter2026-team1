/*
Unit tests for dashboard dependency injections.

These tests ensure the dashboard feature registers its expected factory bindings
with getIt.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/dashboard_injections.dart';
import 'package:search_cms/features/dashboard/data/data_sources/get_all_areas_api_impl.dart';
import 'package:search_cms/features/dashboard/data/data_sources/get_all_levels_api_impl.dart';
import 'package:search_cms/features/dashboard/data/data_sources/get_all_sites_api_impl.dart';
import 'package:search_cms/features/dashboard/data/data_sources/get_all_units_api_impl.dart';
import 'package:search_cms/features/dashboard/data/repositories/get_all_areas_repository_impl.dart';
import 'package:search_cms/features/dashboard/data/repositories/get_all_levels_repository_impl.dart';
import 'package:search_cms/features/dashboard/data/repositories/get_all_sites_repository_impl.dart';
import 'package:search_cms/features/dashboard/data/repositories/get_all_units_repository_impl.dart';
import 'package:search_cms/features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_areas_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_levels_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_sites_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_units_usecase.dart';

void main() {
  group('initDashboardInjections', () {
    setUp(() async {
      await getIt.reset();
    });

    tearDown(() async {
      await getIt.reset();
    });

    test('registers GetAllSitesApiImpl', () {
      initDashboardInjections();

      expect(getIt.isRegistered<GetAllSitesApiImpl>(), isTrue);
    });

    test('registers GetAllSitesRepositoryImpl', () {
      initDashboardInjections();

      expect(getIt.isRegistered<GetAllSitesRepositoryImpl>(), isTrue);
    });

    test('registers GetAllSitesUseCase', () {
      initDashboardInjections();

      expect(getIt.isRegistered<GetAllSitesUseCase>(), isTrue);
    });

    test('registers GetAllAreasApiImpl', () {
      initDashboardInjections();

      expect(getIt.isRegistered<GetAllAreasApiImpl>(), isTrue);
    });

    test('registers GetAllAreasRepositoryImpl', () {
      initDashboardInjections();

      expect(getIt.isRegistered<GetAllAreasRepositoryImpl>(), isTrue);
    });

    test('registers GetAllAreasUseCase', () {
      initDashboardInjections();

      expect(getIt.isRegistered<GetAllAreasUseCase>(), isTrue);
    });

    test('registers GetAllUnitsApiImpl', () {
      initDashboardInjections();

      expect(getIt.isRegistered<GetAllUnitsApiImpl>(), isTrue);
    });

    test('registers GetAllUnitsRepositoryImpl', () {
      initDashboardInjections();

      expect(getIt.isRegistered<GetAllUnitsRepositoryImpl>(), isTrue);
    });

    test('registers GetAllUnitsUseCase', () {
      initDashboardInjections();

      expect(getIt.isRegistered<GetAllUnitsUseCase>(), isTrue);
    });

    test('registers GetAllLevelsApiImpl', () {
      initDashboardInjections();

      expect(getIt.isRegistered<GetAllLevelsApiImpl>(), isTrue);
    });

    test('registers GetAllLevelsRepositoryImpl', () {
      initDashboardInjections();

      expect(getIt.isRegistered<GetAllLevelsRepositoryImpl>(), isTrue);
    });

    test('registers GetAllLevelsUseCase', () {
      initDashboardInjections();

      expect(getIt.isRegistered<GetAllLevelsUseCase>(), isTrue);
    });

    test('registers DashboardUsecases', () {
      initDashboardInjections();

      expect(getIt.isRegistered<DashboardUsecases>(), isTrue);
    });
  });
}