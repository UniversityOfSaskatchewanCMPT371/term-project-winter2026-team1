//import 'package:glados/glados.dart';
import 'package:search_cms/features/dashboard/data/models/artifact_faunal_model.dart';
import 'package:search_cms/features/dashboard/domain/entities/artifact_faunal_entity.dart';

//import '../../../pbt_utils/pbt_utils.dart';

// TODO
// Add these to pbt_utils tomorrow

// Produces null or an int between 1-5 (for porosity)
extension AnyNullablePorosity on Any {
  Generator<int?> get nullablePorosity => any.either(
    any.intInRange(1, 6), // 1 inclusive, 6 exclusive = 1-5
    any.null_,
  );
}

// Produces a positive int > 0 (for preExcavFrags, postExcavFrags, elements)
extension AnyPositiveInt on Any {
  Generator<int> get positiveInt => any.intInRange(1, null);
}

// Produces [sizeUpper, sizeLower] as a valid pair: both null, or sizeUpper >= sizeLower
extension AnyNullableValidSizeRange on Any {
  Generator<List<double?>> get nullableValidSizeRange => any.either(
    any.always([null, null]),              // both null case
    combine2(                              // both present, upper >= lower
      any.positiveDouble,
      any.positiveDouble,
      (a, b) => a >= b ? [a, b] : [b, a], // ensure ordering
    ),
  );
}