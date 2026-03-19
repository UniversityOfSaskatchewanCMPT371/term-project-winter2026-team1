import 'package:search_cms/features/dashboard/domain/entities/level_entity.dart';
import '../../../../core/utils/class_templates/result.dart';

/*
  Success is a child class of Result. This utilises polymorphism to signal the
  call from the usecase is success.

  @param listOfLevelEntity A list of retrieved LevelEntity
    role
 */
class Success extends Result {
  final List<LevelEntity> listOfLevelEntity;

  Success({required this.listOfLevelEntity});
}

/*
  Failure is a child class of Result. This utilises polymorphism to signal the
  call from the usecase is failure.

  @param errorMessage The error message from the api call
 */
class Failure extends Result {
  final String errorMessage;

  Failure({required this.errorMessage});
}