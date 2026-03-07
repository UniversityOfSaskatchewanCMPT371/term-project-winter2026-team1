import '../repositories/abstract_dashboard_repository.dart';

class CreateLevelUseCase {
  final AbstractDashboardRepository repository;

  CreateLevelUseCase(this.repository);

  Future<void> call({
    required String unitId,
    required String name,
    required int upLimit,
    required int lowLimit,
    String? parentId,
    String? levelChar,
    int? levelInt,
  }) {
    return repository.createLevel(
      unitId: unitId,
      name: name,
      upLimit: upLimit,
      lowLimit: lowLimit,
      parentId: parentId,
      levelChar: levelChar,
      levelInt: levelInt,
    );
  }
}