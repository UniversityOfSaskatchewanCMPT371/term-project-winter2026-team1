import 'package:glados/glados.dart';
import 'package:search_cms/features/dashboard/data/models/artifact_faunal_model.dart';
import 'package:search_cms/features/dashboard/domain/entities/artifact_faunal_entity.dart';

import '../../../pbt_utils/pbt_utils.dart';

// Generates an ArtifactFaunalEntity with random values that satisfy all invariants
// call with 'artifactFaunalEntity'
extension AnyArtifactFaunalEntity on Any {
  Generator<ArtifactFaunalEntity> get artifactFaunalEntity => combine10(
    any.uuid,                     // id
    any.uuid,                     // assemblageId
    any.nullablePorosity,         // porosity: null or int between 1-5
    any.nullableValidSizeRange,   // [sizeUpper, sizeLower]: null pair or valid ordered pair
    any.letters,                  // comment: string or empty, never null (entity requires String)
    any.intInRange(1, null),      // preExcavFrags > 0
    any.intInRange(1, null),      // postExcavFrags > 0
    any.intInRange(1, null),      // elements > 0
    any.dateTime,                 // createdAt
    any.dateTime,                 // updatedAt
    (id, assemblageId, porosity, sizePair, comment, preExcavFrags, postExcavFrags, elements, createdAt, updatedAt) {
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
        updatedAt: updatedAt,  // use same datetime to keep combine9 within the 9-arg limit
      );
    }
  );
}
 
// Generates an ArtifactFaunalModel with random values
// call with 'artifactFaunalModel'
extension AnyArtifactFaunalModel on Any {
  Generator<ArtifactFaunalModel> get artifactFaunalModel => combine10(
    any.uuid,                     // id
    any.uuid,                     // assemblageId
    any.nullablePorosity,         // porosity: null or int between 1-5
    // The 'combine' method is limited to ten fields so we use porosity as a tuple
    any.nullableValidSizeRange,   // [sizeUpper, sizeLower]: null pair or valid ordered pair
    any.nullableLetters,          // comment: string, empty string, or null (model allows null)
    any.intInRange(1, null),              // preExcavFrags > 0
    any.intInRange(1, null),              // postExcavFrags > 0
    any.intInRange(1, null),              // elements > 0
    any.dateTime,                 // createdAt
    any.dateTime,                 // updatedAt
    (id, assemblageId, porosity, sizePair, comment, preExcavFrags, postExcavFrags, elements, createdAt, updatedAt) {
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
        updatedAt: updatedAt,
      );
    }
  );
}


// Runs randomized property-based tests on the ArtifactFaunalEntity and ArtifactFaunalModel class
// This tests the invariants of the entity against generated Glados instances
// The unit tests already cover the edge cases where required fields are empty or
// constrained fields are out of range, so this test does not attempt to target those
void main() {
  group('ARTIFACT-FAUNAL-PBT : Entity and Model PBT Tests', () {
 
    /*** Test 1 - ArtifactFaunalEntity ***/
    // Creates a randomly generated entity and verifies its contents
    Any.setDefault<ArtifactFaunalEntity>(any.artifactFaunalEntity);
 
    Glados<ArtifactFaunalEntity>().test(
      'generated ArtifactFaunalEntity has valid fields',
      (artifactFaunalEntity) {
        // id and assemblageId must be valid UUIDs — non-empty and correct format
        expect(artifactFaunalEntity.id, isNotEmpty);
        expect(artifactFaunalEntity.id, matches(
          RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
        ));
 
        expect(artifactFaunalEntity.assemblageId, isNotEmpty);
        expect(artifactFaunalEntity.assemblageId, matches(
          RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
        ));
 
        // porosity must be null or between 1-5
        if (artifactFaunalEntity.porosity != null) {
          expect(artifactFaunalEntity.porosity, greaterThanOrEqualTo(1));
          expect(artifactFaunalEntity.porosity, lessThanOrEqualTo(5));
        }
 
        // sizeUpper >= sizeLower when both are present
        if (artifactFaunalEntity.sizeUpper != null && artifactFaunalEntity.sizeLower != null) {
          expect(artifactFaunalEntity.sizeUpper, greaterThanOrEqualTo(artifactFaunalEntity.sizeLower!));
        }
 
        // comment is always a String (never null) on the entity
        expect(artifactFaunalEntity.comment, isA<String>());
 
        // fragment and element counts must all be > 0
        expect(artifactFaunalEntity.preExcavFrags, greaterThan(0));
        expect(artifactFaunalEntity.postExcavFrags, greaterThan(0));
        expect(artifactFaunalEntity.elements, greaterThan(0));
 
        // dates must be valid DateTime instances
        expect(artifactFaunalEntity.createdAt, isA<DateTime>());
        expect(artifactFaunalEntity.updatedAt, isA<DateTime>());
      }
    );


    /*** Test 2 - ArtifactFaunalModel ***/
    // Creates a randomly generated model and verifies its contents
    Any.setDefault<ArtifactFaunalModel>(any.artifactFaunalModel);
 
    Glados<ArtifactFaunalModel>().test(
      'generated ArtifactFaunalModel has valid fields',
      (artifactFaunalModel) {
        // id and assemblageId must be valid UUIDs — non-empty and correct format
        expect(artifactFaunalModel.id, isNotEmpty);
        expect(artifactFaunalModel.id, matches(
          RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
        ));
 
        expect(artifactFaunalModel.assemblageId, isNotEmpty);
        expect(artifactFaunalModel.assemblageId, matches(
          RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
        ));
 
        // porosity must be null or between 1-5
        if (artifactFaunalModel.porosity != null) {
          expect(artifactFaunalModel.porosity, greaterThanOrEqualTo(1));
          expect(artifactFaunalModel.porosity, lessThanOrEqualTo(5));
        }
 
        // sizeUpper >= sizeLower when both are present
        if (artifactFaunalModel.sizeUpper != null && artifactFaunalModel.sizeLower != null) {
          expect(artifactFaunalModel.sizeUpper, greaterThanOrEqualTo(artifactFaunalModel.sizeLower!));
        }
 
        // comment is nullable on the model
        if (artifactFaunalModel.comment != null) {
          expect(artifactFaunalModel.comment, isA<String>());
        }
 
        // fragment and element counts must all be > 0
        expect(artifactFaunalModel.preExcavFrags, greaterThan(0));
        expect(artifactFaunalModel.postExcavFrags, greaterThan(0));
        expect(artifactFaunalModel.elements, greaterThan(0));
 
        // dates must be valid DateTime instances
        expect(artifactFaunalModel.createdAt, isA<DateTime>());
        expect(artifactFaunalModel.updatedAt, isA<DateTime>());
      }
    );


    /*** Test 3 - toEntity() ***/
    // Ensures any model, when converted to an entity, will be both
    // a valid entity and will carry the same values as the model
    Glados<ArtifactFaunalModel>().test(
      'toEntity() returns a valid ArtifactFaunalEntity with the same values',
      (artifactFaunalModel) {
 
        final entity = artifactFaunalModel.toEntity();
 
        // Entity is the correct type
        expect(entity, isA<ArtifactFaunalEntity>());
 
        // Returned entity has the same values for all fields
        expect(entity.id, artifactFaunalModel.id);
        expect(entity.assemblageId, artifactFaunalModel.assemblageId);
        expect(entity.porosity, artifactFaunalModel.porosity);
        expect(entity.sizeUpper, artifactFaunalModel.sizeUpper);
        expect(entity.sizeLower, artifactFaunalModel.sizeLower);
 
        // If model.comment is null it gets converted to empty string in toEntity()
        if (artifactFaunalModel.comment == null) {
          expect(entity.comment, isEmpty);
        } else {
          expect(entity.comment, artifactFaunalModel.comment);
        }
 
        expect(entity.preExcavFrags, artifactFaunalModel.preExcavFrags);
        expect(entity.postExcavFrags, artifactFaunalModel.postExcavFrags);
        expect(entity.elements, artifactFaunalModel.elements);
        expect(entity.createdAt, artifactFaunalModel.createdAt);
        expect(entity.updatedAt, artifactFaunalModel.updatedAt);
      }
    );
 
  });
}