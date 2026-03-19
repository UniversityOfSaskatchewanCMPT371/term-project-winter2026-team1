import '../../../../core/utils/class_templates/result.dart';
import 'unit_entity.dart';


/*
  Success is a child class of Result. This utilises polymorphism to signal the
  call from the usecase is success.

  @param listOfUnitEntity A list of retrieved UnitEntity
    role
 */
class Success extends Result {
  final List<UnitEntity> listOfUnitEntity;

  Success({required this.listOfUnitEntity});
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