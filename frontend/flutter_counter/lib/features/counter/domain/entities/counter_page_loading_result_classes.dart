import 'package:flutter_supabase_template/features/counter/domain/entities/counter_entity.dart';
import 'package:flutter_supabase_template/utils/class_templates/result.dart';

class Success extends Result {
  final CounterEntity counterEntity;

  Success({required this.counterEntity});
}

class Failure extends Result {
  final String errorMessage;

  Failure({required this.errorMessage});
}