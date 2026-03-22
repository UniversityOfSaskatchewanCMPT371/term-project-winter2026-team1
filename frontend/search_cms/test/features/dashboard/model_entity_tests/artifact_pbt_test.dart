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


// Generates an ArtifactFaunalEntity with random values that satisfy all invariants
// call with 'artifactFaunalEntity'
extension AnyArtifactFaunalEntity on Any {
  Generator<ArtifactFaunalEntity> get artifactFaunalEntity => combine9(
    any.uuid,                     // id
    any.uuid,                     // assemblageId
    any.nullablePorosity,         // porosity: null or int between 1-5
    any.nullableValidSizeRange,   // [sizeUpper, sizeLower]: null pair or valid ordered pair
    any.letters,                  // comment: string or empty, never null (entity requires String)
    any.positiveInt,              // preExcavFrags > 0
    any.positiveInt,              // postExcavFrags > 0
    any.positiveInt,              // elements > 0
    any.dateTime,                 // createdAt
    (id, assemblageId, porosity, sizePair, comment, preExcavFrags, postExcavFrags, elements, createdAt) {
      return ArtifactFaunalEntity(
        id: id,
        assemblageId: assemblageId,
        porosity: porosity,
        sizeUpper: sizePair[0],
        sizeLower: sizePair[1],
        comment: comment,
        preExcavFrags: preExcavFrags,
        postExcavFrags: postExcavFrags,
        elements: elements,
        createdAt: createdAt,
        updatedAt: createdAt,  // use same datetime to keep combine9 within the 9-arg limit
      );
    }
  );
}
 
// Generates an ArtifactFaunalModel with random values
// call with 'artifactFaunalModel'
extension AnyArtifactFaunalModel on Any {
  Generator<ArtifactFaunalModel> get artifactFaunalModel => combine9(
    any.uuid,                     // id
    any.uuid,                     // assemblageId
    any.nullablePorosity,         // porosity: null or int between 1-5
    any.nullableValidSizeRange,   // [sizeUpper, sizeLower]: null pair or valid ordered pair
    any.nullableLetters,          // comment: string, empty string, or null (model allows null)
    any.positiveInt,              // preExcavFrags > 0
    any.positiveInt,              // postExcavFrags > 0
    any.positiveInt,              // elements > 0
    any.dateTime,                 // createdAt
    (id, assemblageId, porosity, sizePair, comment, preExcavFrags, postExcavFrags, elements, createdAt) {
      return ArtifactFaunalModel(
        id: id,
        assemblageId: assemblageId,
        porosity: porosity,
        sizeUpper: sizePair[0],
        sizeLower: sizePair[1],
        comment: comment,
        preExcavFrags: preExcavFrags,
        postExcavFrags: postExcavFrags,
        elements: elements,
        createdAt: createdAt,
        updatedAt: createdAt,
      );
    }
  );
}