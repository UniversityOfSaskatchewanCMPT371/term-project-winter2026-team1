import '../../../../core/utils/class_templates/result.dart';
import 'area_entity.dart';

/*
  Success is a child class of Result. This utilises polymorphism to signal the
  call from usecase is success.

  @param areaEntity An AreaEntity class that contains the inserted area data
 */
class Success extends Result {
  final AreaEntity areaEntity;

  Success({required this.areaEntity});
}

/*
  Failure is a child class of Result. This utilises polymorphism to signal the
  call from usecase is failure.

  @param errorMessage The error message from the api call
 */
class Failure extends Result {
  final String errorMessage;

  Failure({required this.errorMessage});
}
