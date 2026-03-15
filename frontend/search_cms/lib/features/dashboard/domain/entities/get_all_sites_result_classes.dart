import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/features/dashboard/domain/entities/site_entity.dart';

/*
  Success is a child class of Result. This utilises polymorphism to signal the
  call from the usecase is success.

  @param listOfSiteEntity A list of retrieved SiteEntity
    role
 */
class Success extends Result {
  final List<SiteEntity> listOfSiteEntity;

  Success({required this.listOfSiteEntity});
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