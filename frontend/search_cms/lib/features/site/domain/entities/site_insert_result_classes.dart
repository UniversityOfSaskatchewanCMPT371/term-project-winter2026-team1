import '../../../../core/utils/class_templates/result.dart';
import 'site_entity.dart';

/*
  Success is a child class of Result. This utilises polymorphism to signal the
  call from usecase is success.

  @param siteEntity A SiteEntity class that contains the inserted site data
 */
class Success extends Result {
  final SiteEntity siteEntity;

  Success({required this.siteEntity});
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
