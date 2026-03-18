import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/dashboard/data/models/assemblage_model.dart';
import 'package:search_cms/features/dashboard/domain/entities/assemblage_entity.dart';

void main() {

  final DateTime now = DateTime.now();

  /********************************************** LevelEntity Tests **********************************************/

  // Test Case 1: General Test Case
  test('Create entity with valid inputs', () {
    final AssemblageEntity entity = AssemblageEntity(
      id: '88888888-8888-8888-8888-888888888888', 
      levelId: '77777777-7777-7777-7777-777777777777', 
      name: 'Level 1 Faunal Assemblage', 
      createdAt: now, 
      updatedAt: now,
    );

    expect(entity.id, '88888888-8888-8888-8888-888888888888');
    expect(entity.levelId, '77777777-7777-7777-7777-777777777777');
    expect(entity.name, 'Level 1 Faunal Assemblage');
    expect(entity.createdAt, now);
    expect(entity.updatedAt, now);
  });

  /*-----------------------------------------------------------------*/

  // Test Case 2: Test with an Empty Name
  test('Create entity with an empty name', () {
    final AssemblageEntity entity = AssemblageEntity(
      id: '88888888-8888-8888-8888-888888888888', 
      levelId: '77777777-7777-7777-7777-777777777777', 
      name: '', 
      createdAt: now, 
      updatedAt: now,
    );

    expect(entity.id, '88888888-8888-8888-8888-888888888888');
    expect(entity.levelId, '77777777-7777-7777-7777-777777777777');
    expect(entity.name, '');
    expect(entity.createdAt, now);
    expect(entity.updatedAt, now);
  });

  /*-----------------------------------------------------------------*/

  // Test Case 3: Test Assertions

  // 3(a): Empty ID
  test('Will throw an AssertionError if id is empty', () {
    expect(() => AssemblageEntity(id: '', levelId: '77777777-7777-7777-7777-777777777777', name: '', createdAt: now, updatedAt: now),
      throwsA(isA<AssertionError>()));
  });

  // 3(b): Empty Level ID
  test('Will throw an AssertionError if levelId is empty', () {
    expect(() => AssemblageEntity(id: '88888888-8888-8888-8888-888888888888', levelId: '', name: '', createdAt: now, updatedAt: now),
      throwsA(isA<AssertionError>()));
  });

  /*-----------------------------------------------------------------*/

  /********************************************** LevelModel Tests ***********************************************/

  // Test Case 4: General Test Case
  test('Create model with valid inputs', () {
    final AssemblageModel model = AssemblageModel(
      id: '88888888-8888-8888-8888-888888888888', 
      levelId: '77777777-7777-7777-7777-777777777777', 
      name: 'Level 1 Faunal Assemblage', 
      createdAt: now, 
      updatedAt: now,
    );

    expect(model.id, '88888888-8888-8888-8888-888888888888');
    expect(model.levelId, '77777777-7777-7777-7777-777777777777');
    expect(model.name, 'Level 1 Faunal Assemblage');
    expect(model.createdAt, now);
    expect(model.updatedAt, now);
  });

  /*-----------------------------------------------------------------*/

  // Test Case 5: Test toEntity() Function

  // 5(a): Return LevelEntity with Same Values
  test('toEntity() should return AssemblageEntity with same values it had before conversion', () {
    final AssemblageModel model = AssemblageModel(
      id: '88888888-8888-8888-8888-888888888888', 
      levelId: '77777777-7777-7777-7777-777777777777', 
      name: 'Level 1 Faunal Assemblage', 
      createdAt: now, 
      updatedAt: now,
    );

    final AssemblageEntity entity = model.toEntity();

    expect(entity.id, model.id);
    expect(entity.levelId, model.levelId);
    expect(entity.name, model.name);
    expect(entity.createdAt, model.createdAt);
    expect(entity.updatedAt, model.updatedAt);
  });

  // 5(b): Ensure toEntity() Returns a LevelEntity
  test('Ensure toEntity() funtion returns an AssemblageEntity', () {
    final AssemblageModel model = AssemblageModel(
      id: '88888888-8888-8888-8888-888888888888', 
      levelId: '77777777-7777-7777-7777-777777777777', 
      name: 'Level 1 Faunal Assemblage', 
      createdAt: now, 
      updatedAt: now,
    );

    expect(model.toEntity(), isA<AssemblageEntity>());
  });

  /*-----------------------------------------------------------------*/
}



