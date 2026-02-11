import 'package:flutter_supabase_template/core/utils/class_templates/result.dart';
import 'package:flutter_supabase_template/features/counter/domain/entities/counter_entity.dart';

class Success extends Result {
  final CounterEntity counterEntity;

  Success({required this.counterEntity});
}

class Failure extends Result {
  final String errorMessage;

  Failure({required this.errorMessage});
}