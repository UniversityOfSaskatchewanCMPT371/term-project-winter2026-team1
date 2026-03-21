import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/features/dashboard/domain/entities/area_entity.dart';


/*
  Success is a child class of Result. This utilises polymorphism to signal the
  call from the usecase is success.

  @param listOfAreaEntity A list of retrieved AreaEntity
    role
 */
class Success extends Result {
  final List<AreaEntity> listOfAreaEntity;

  Success({required this.listOfAreaEntity});
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