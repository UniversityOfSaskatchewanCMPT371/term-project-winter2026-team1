import 'package:search_cms/features/dashboard/domain/usecases/get_all_areas_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_levels_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_sites_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_units_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/insert_area_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/insert_assemblage_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/insert_level_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/insert_site_area_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/insert_site_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/insert_unit_usecase.dart';

// The collection of all use cases for the dashboard
class DashboardUsecases {
  final GetAllSitesUseCase getAllSitesUseCase;
  final GetAllAreasUseCase getAllAreasUseCase;
  final GetAllUnitsUseCase getAllUnitsUseCase;
  final GetAllLevelsUseCase getAllLevelsUseCase;
  final InsertSiteUsecase insertSiteUsecase;
  final InsertAreaUsecase insertAreaUsecase;
  final InsertSiteAreaUsecase insertSiteAreaUsecase;
  final InsertUnitUsecase insertUnitUsecase;
  final InsertLevelUsecase insertLevelUsecase;
  final InsertAssemblageUsecase insertAssemblageUsecase;

  DashboardUsecases({
    required this.getAllSitesUseCase,
    required this.getAllAreasUseCase,
    required this.getAllUnitsUseCase,
    required this.getAllLevelsUseCase,
    required this.insertSiteUsecase,
    required this.insertAreaUsecase,
    required this.insertSiteAreaUsecase,
    required this.insertUnitUsecase,
    required this.insertLevelUsecase,
    required this.insertAssemblageUsecase,
  });
}