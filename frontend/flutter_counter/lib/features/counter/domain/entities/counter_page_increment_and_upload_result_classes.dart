import 'package:flutter_supabase_template/utils/class_templates/result.dart';

class Success extends Result {}

class Failure extends Result {
  final String errorMessage;

  Failure({required this.errorMessage});
}