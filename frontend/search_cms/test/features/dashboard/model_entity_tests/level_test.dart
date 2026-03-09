import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/dashboard/data/models/level_model.dart';
import 'package:search_cms/features/dashboard/domain/entities/level_entity.dart';

void main() {

  final DateTime now = DateTime.now();


  // LevelEntity tests
  // General test case
  test('create entity with valid inputs', () {
    final LevelEntity entity = LevelEntity(
      id: 'abcd12345',
      unitId: '12345abcd',
      name: 'some level',
      upLimit: 0,
      lowLimit: 10,
      createdAt: now,
      updatedAt: now,
    );

    expect(entity.id, 'abcd12345');
    expect(entity.unitId, '12345abcd');
    expect(entity.name, 'some level');
    expect(entity.upLimit, 0);
    expect(entity.lowLimit, 10);
    expect(entity.parentId, null);
    expect(entity.createdAt, now);
    expect(entity.updatedAt, now);
  });

  // General case with optional fields
  test('create entity with optional fields all valid', () {
    final LevelEntity entity = LevelEntity(
      id: 'abcd12345',
      unitId: '12345abcd',
      parentId: '12345',
      name: 'some level',
      upLimit: 0,
      lowLimit: 10,
      levelChar: 'A',
      levelInt: 1,
      createdAt: now,
      updatedAt: now,
    );

    expect(entity.parentId, '12345');
    expect(entity.levelChar, 'A');
    expect(entity.levelInt, 1);
  });

  // Test the assertions in level_entity.dart
  test('will throw AssertionError if id is empty', () {
    expect(() => LevelEntity(id: '', unitId: '12345abcd', name: 'some level', upLimit: 0, lowLimit: 10, createdAt: now, updatedAt: now),
      throwsA(isA<AssertionError>()));
  });

  test('will throw AssertionError if unitId is empty', () {
    expect(() => LevelEntity(id: 'abcd12345', unitId: '', name: 'some level', upLimit: 0, lowLimit: 10, createdAt: now, updatedAt: now),
      throwsA(isA<AssertionError>()));
  });

  test('will throw AssertionError if name is empty', () {
    expect(() => LevelEntity(id: 'abcd12345', unitId: '12345abcd', name: '', upLimit: 0, lowLimit: 10, createdAt: now, updatedAt: now),
      throwsA(isA<AssertionError>()));
  });

  test('will throw AssertionError if upLimit > lowLimit', () {
    expect(() => LevelEntity(id: 'abcd12345', unitId: '12345abcd', name: 'some level', upLimit: 10, lowLimit: 5, createdAt: now, updatedAt: now),
      throwsA(isA<AssertionError>()));
  });

  test('will throw AssertionError if levelChar is more than one character', () {
    expect(() => LevelEntity(id: 'abcd12345', unitId: '12345abcd', name: 'some level', upLimit: 0, lowLimit: 10, levelChar: 'AB', createdAt: now, updatedAt: now),
      throwsA(isA<AssertionError>()));
  });

  // We could later separate these groups of tests (model and entity) into different dirs/files

  // LevelModel tests
  // General test case
  test('create model with valid inputs', () {
    final LevelModel model = LevelModel(
      id: 'abcd12345',
      unitId: '12345abcd',
      name: 'some level',
      upLimit: 0,
      lowLimit: 10,
      createdAt: now,
      updatedAt: now,
    );

    expect(model.id, 'abcd12345');
    expect(model.unitId, '12345abcd');
    expect(model.name, 'some level');
    expect(model.upLimit, 0);
    expect(model.lowLimit, 10);
    expect(model.createdAt, now);
    expect(model.updatedAt, now);
  });

  // Test the toEntity() function
  test('toEntity() should return LevelEntity with same values it had before conversion', () {
    final LevelModel model = LevelModel(
      id: 'abcd12345',
      unitId: '12345abcd',
      parentId: '12345',
      name: 'some level',
      upLimit: 0,
      lowLimit: 10,
      levelChar: 'A',
      levelInt: 1,
      createdAt: now,
      updatedAt: now,
    );
    final LevelEntity entity = model.toEntity();

    expect(entity.id, model.id);
    expect(entity.unitId, model.unitId);
    expect(entity.parentId, model.parentId);
    expect(entity.name, model.name);
    expect(entity.upLimit, model.upLimit);
    expect(entity.lowLimit, model.lowLimit);
    expect(entity.levelChar, model.levelChar);
    expect(entity.levelInt, model.levelInt);
    expect(entity.createdAt, model.createdAt);
    expect(entity.updatedAt, model.updatedAt);
  });

  test('make sure toEntity() function returns a LevelEntity', () {
    final LevelModel model = LevelModel(
      id: 'abcd12345',
      unitId: '12345abcd',
      name: 'some level',
      upLimit: 0,
      lowLimit: 10,
      createdAt: now,
      updatedAt: now,
    );

    expect(model.toEntity(), isA<LevelEntity>());
  });
  // TODO: add tests using mocked sqlite.Row for fromRow()
}