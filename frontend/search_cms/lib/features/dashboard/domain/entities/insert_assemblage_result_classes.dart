import 'package:search_cms/core/utils/class_templates/result.dart';

/*
  Success is a child class of Result. This utilises polymorphism to signal the
  call from the usecase is success.
*/
class Success extends Result {
  const Success();
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