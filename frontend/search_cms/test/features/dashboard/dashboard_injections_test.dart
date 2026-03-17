/*
Unit tests for dashboard dependency injections.

These tests ensure the dashboard feature registers its expected factory bindings
with getIt.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/dashboard_injections.dart';
import 'package:search_cms/features/dashboard/data/data_sources/get_all_sites_api_impl.dart';
import 'package:search_cms/features/dashboard/data/repositories/get_all_sites_repository_impl.dart';
import 'package:search_cms/features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_sites_usecase.dart';

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

    test('registers DashboardUsecases', () {
      initDashboardInjections();

      expect(getIt.isRegistered<DashboardUsecases>(), isTrue);
    });
  });
}