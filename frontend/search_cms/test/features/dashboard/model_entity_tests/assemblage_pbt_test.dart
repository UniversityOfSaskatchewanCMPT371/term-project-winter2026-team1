import 'package:flutter_test/flutter_test.dart';
import 'package:glados/glados.dart';

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

// produces either a string, and empty string, or null
extension MaybeAnyString on Any {
  // any.either randomly chooses between its two arguments
  Generator<String?> get nullableLetters => any.either(
    any.letters,  // string, can be empty
    any.null_,    // always null
  );
}

// Generates an Assemblage with random values
extension AnyAssemblage on Any {
  Generator<AssemblageEntity> get assemblage => combine5(
    any.nonEmptyLetters,
    any.nonEmptyLetters,
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
  // A generator for UUID-like strings (not strict UUID validation—just realistic/structured data)
  final uuidGen = any
      .map((_) => List.generate(32, (i) => "0123456789abcdef"[any.int.restrict(0, 15).generate()]))
      .map((chars) {
        final s = chars.join();
        return '${s.substring(0, 8)}-'
               '${s.substring(8, 12)}-'
               '${s.substring(12, 16)}-'
               '${s.substring(16, 20)}-'
               '${s.substring(20)}';
      });

  // Generator for nullable or non-null names
  final nameGen = any.stringOrNull;

  // Generator for timestamps
  final dateGen = any.dateTime;

  Glados3(uuidGen, uuidGen, nameGen).test(
    'Entity retains provided data',
    (id, levelId, name) {
      final createdAt = dateGen.generate();
      final updatedAt = dateGen.generate();

      final entity = AssemblageEntity(
        id: id,
        levelId: levelId,
        name: name,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(entity.id, id);
      expect(entity.levelId, levelId);
      expect(entity.name, name);
      expect(entity.createdAt, createdAt);
      expect(entity.updatedAt, updatedAt);
    },
  );
}
