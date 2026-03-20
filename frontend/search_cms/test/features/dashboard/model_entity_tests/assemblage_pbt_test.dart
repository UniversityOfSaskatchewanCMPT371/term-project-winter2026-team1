//import 'package:flutter_test/flutter_test.dart' hide group;
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

// Generates an Assemblage with random values
extension AnyAssemblage on Any {
  Generator<AssemblageEntity> get assemblage => combine5(
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

void main() {
  group('Assemblage PBT Tests', () {
    
    Any.setDefault<AssemblageEntity>(any.assemblage);

    Glados<AssemblageEntity>().test("test", (assemblage) {
      AssemblageEntity entity = assemblage;

      expect(entity.id, id);
      expect(entity.levelId, levelId);
      expect(entity.name, name);
      expect(entity.createdAt, createdAt);
      expect(entity.updatedAt, updatedAt);
    });
  },
  );
}
