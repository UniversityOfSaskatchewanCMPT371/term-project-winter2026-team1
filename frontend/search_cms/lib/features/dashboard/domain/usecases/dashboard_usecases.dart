<<<<<<< HEAD
import 'package:search_cms/features/dashboard/domain/usecases/get_all_areas_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_levels_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_sites_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_units_usecase.dart';
=======
import 'package:search_cms/features/dashboard/domain/usecases/get_all_sites_usecase.dart';
>>>>>>> 1d4141e (Get all sites use case is complete.)

// The collection of all use cases for the dashboard
class DashboardUsecases {
  final GetAllSitesUseCase getAllSitesUseCase;
<<<<<<< HEAD
  final GetAllAreasUseCase getAllAreasUseCase;
  final GetAllUnitsUseCase getAllUnitsUseCase;
  final GetAllLevelsUseCase getAllLevelsUseCase;

  DashboardUsecases({
    required this.getAllSitesUseCase,
    required this.getAllAreasUseCase,
    required this.getAllUnitsUseCase,
    required this.getAllLevelsUseCase,
  });
}
=======

  DashboardUsecases({required this.getAllSitesUseCase});
}
>>>>>>> 1d4141e (Get all sites use case is complete.)
