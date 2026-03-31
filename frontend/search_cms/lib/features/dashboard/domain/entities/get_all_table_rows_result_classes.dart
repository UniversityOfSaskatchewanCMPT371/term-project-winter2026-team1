import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/features/dashboard/domain/entities/table_row_entity.dart';


/*
  Success is a child class of Result. This utilises polymorphism to signal the
  call from the usecase is success.

  @param listOfTableRowEntity A list of retrieved TableRowEntity
    role
 */
class Success extends Result {
  final List<TableRowEntity> listOfTableRowEntity;

  Success({required this.listOfTableRowEntity});
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