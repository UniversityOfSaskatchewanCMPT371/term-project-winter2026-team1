import 'package:glados/glados.dart';
import '../../../pbt_utils/pbt_utils.dart';

// Copied over until class gets merged to develop, remove later
class AssemblageEntity {
  final String id;
  final String levelId;
  final String? name;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssemblageEntity({
    required this.id,
    required this.levelId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
}
class AssemblageModel {
  final String id;
  final String levelId;
  final String? name; // Name can be empty or non-empty
  final DateTime createdAt;
  final DateTime updatedAt;

  AssemblageModel({
    required this.id,
    required this.levelId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
}

// Generates an AssemblageEntity with random values
// call with assemblageEntity
extension AnyAssemblageEntity on Any {
  Generator<AssemblageEntity> get assemblageEntity => combine5(
    any.uuid,
    any.uuid,
    nullableLetters,
    any.dateTime,
    any.dateTime,
    (id, levelId, name, createdAt, updatedAt) {
      return AssemblageEntity(
        id: id,
        levelId: levelId,
        name: name,
        createdAt: createdAt,
        updatedAt: updatedAt);
    }
  );
}

// Generates an AssemblageModel with random values
// call with assemblageModel
extension AnyAssemblageModel on Any {
  Generator<AssemblageModel> get assemblageModel => combine5(
    any.uuid,
    any.uuid,
    nullableLetters,
    any.dateTime,
    any.dateTime,
    (id, levelId, name, createdAt, updatedAt) {
      return AssemblageModel(
        id: id,
        levelId: levelId,
        name: name,
        createdAt: createdAt,
        updatedAt: updatedAt);
    }
  );
}

// Runs randomized property-based tests on the AssemblageEntity and AssemblageModel class
// This tests the invariants of the entity against generated Glados instances
// The unit tests already cover the edge cases where any one required 
// field (ID, level ID) is empty, so this test does not attempt to target that
void main() {
  group('Entity and Model PBT Tests', () {
    
    /*** Test 1 - AssemblageEntity ***/
    Any.setDefault<AssemblageEntity>(any.assemblageEntity);

    Glados<AssemblageEntity>().test(
      "generated AssemblageEntity has valid fields",
      (assemblageEntity) {
        // id and levelId must be valid UUIDs, non-empty and correct format
        expect(assemblageEntity.id, isNotEmpty);
        expect(assemblageEntity.id, matches(
          RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
        ));

        expect(assemblageEntity.levelId, isNotEmpty);
        expect(assemblageEntity.levelId, matches(
          RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
        ));

        // name is nullable, if present it must be a String
        if (assemblageEntity.name != null) {
          expect(assemblageEntity.name, isA<String>());
        }

        // dates must be valid DateTime instances
        expect(assemblageEntity.createdAt, isA<DateTime>());
        expect(assemblageEntity.updatedAt, isA<DateTime>());
    });


    /*** Test 2 - AssemblageModel ***/
    Any.setDefault(any.assemblageModel);

    Glados<AssemblageModel>().test(
      "generated AssemblageModel has valid fields",
      (assemblageModel) {
        // id and levelId must be valid UUIDs, non-empty and correct format
        expect(assemblageModel.id, isNotEmpty);
        expect(assemblageModel.id, matches(
          RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
        ));

        expect(assemblageModel.levelId, isNotEmpty);
        expect(assemblageModel.levelId, matches(
          RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
        ));

        // name is nullable, if present it must be a String
        if (assemblageModel.name != null) {
          expect(assemblageModel.name, isA<String>());
        }

        // dates must be valid DateTime instances
        expect(assemblageModel.createdAt, isA<DateTime>());
        expect(assemblageModel.updatedAt, isA<DateTime>());
      }
    );

  /*** Test 3 - toEntity() ***/
  // Ensures any model, when converted to an entity, will be both
  // a valid entity and will carry the same values as the model
   Glados<AssemblageModel>().test(
      "generated AssemblageModel has valid fields",
      (assemblageModel) {
        // PLACEHOLDER
        final AssemblageEntity entity = AssemblageEntity(
          id: '88888888-8888-8888-8888-888888888888', 
          levelId: '77777777-7777-7777-7777-777777777777', 
          name: '', 
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        // REPLACE WITH:
        //final entity = assemblageModel.toEntity();

        // Entity is the correct type
        expect(entity, isA<AssemblageEntity>());

        // Returned entity has the same values
        expect(entity.id, assemblageModel.id);
        expect(entity.levelId, assemblageModel.levelId);
        expect(entity.name, assemblageModel.name);
        expect(entity.createdAt, assemblageModel.createdAt);
        expect(entity.updatedAt, assemblageModel.updatedAt);
    });
  },
  );
}
