import 'package:search_cms/features/dashboard/domain/usecases/get_all_areas_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_levels_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_sites_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_units_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_table_rows_usecase.dart';


// The collection of all use cases for the dashboard
class DashboardUsecases {
  final GetAllSitesUseCase getAllSitesUseCase;
  final GetAllAreasUseCase getAllAreasUseCase;
  final GetAllUnitsUseCase getAllUnitsUseCase;
  final GetAllLevelsUseCase getAllLevelsUseCase;
  final GetAllTableRowsUseCase getAllTableRowsUseCase;


  DashboardUsecases({
    required this.getAllSitesUseCase,
    required this.getAllAreasUseCase,
    required this.getAllUnitsUseCase,
    required this.getAllLevelsUseCase,
    required this.getAllTableRowsUseCase,
  });
}
