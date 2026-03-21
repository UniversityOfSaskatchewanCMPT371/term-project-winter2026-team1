import 'package:search_cms/features/dashboard/domain/usecases/get_all_areas_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_sites_usecase.dart';

// The collection of all use cases for the dashboard
class DashboardUsecases {
  final GetAllSitesUseCase getAllSitesUseCase;
  final GetAllAreasUseCase getAllAreasUseCase;

  DashboardUsecases({
    required this.getAllSitesUseCase,
    required this.getAllAreasUseCase,
  });
}
