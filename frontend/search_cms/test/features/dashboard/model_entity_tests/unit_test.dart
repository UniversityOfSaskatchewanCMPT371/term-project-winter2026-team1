import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/dashboard/data/models/unit_model.dart';
import 'package:search_cms/features/dashboard/domain/entities/unit_entity.dart';

void main() {

  final DateTime now = DateTime.now();


  // UnitEntity tests
  // General test case
  test('create entity wiht valid inputs', () {
    final entity = UnitEntity(
      id: 'abcd12345',
      siteId: '12345abcd',
      name: 'some place',
      createdAt: now,
      updatedAt: now,
    );

    expect(entity.id, 'abcd12345');
    expect(entity.name, 'some place');
    expect(entity.siteId, '12345abcd');
    expect(entity.createdAt, now);
    expect(entity.updatedAt, now);

  });

  // Test the assertions in area_entity.dart
  test('will throw AssertionError if id is empty', () {
    expect(() => UnitEntity(id: '', siteId: '12345abcd', name: 'some place', createdAt: now, updatedAt: now),
      throwsA(isA<AssertionError>()));
  });

  test('will throw AssertionError if siteId is empty', () {
    expect(() => UnitEntity(id: 'abcd12345', siteId: '', name: 'some place', createdAt: now, updatedAt: now),
      throwsA(isA<AssertionError>()));
  });

  test('will throw AssertionError if name is empty', () {
    expect(() => UnitEntity(id: 'abcd12345', siteId: '12345abcd', name: '', createdAt: now, updatedAt: now),
      throwsA(isA<AssertionError>()));
  });

  // We could later seperate these groups of tests (model and entity) into different dirs/files 

  // UnitModel tests 
  // General test case
  test('create model with valid inputs', () {
    final model = UnitModel(
      id: 'abcd12345',
      siteId: '12345abcd',
      name: 'some place',
      createdAt: now,
      updatedAt: now,
    );

    expect(model.id, 'abcd12345');
    expect(model.name, 'some place');
    expect(model.createdAt, now);
    expect(model.updatedAt, now);
  });

  // Test the toEntity() function 
  test('toEntity() should return UnitEntity with same values it had before conversion', () {
    final model = UnitModel(
      id: 'abcd12345',
      siteId: '12345abcd',
      name: 'some place',
      createdAt: now,
      updatedAt: now,
    );
    // Convert the model object to an entity
    final entity = model.toEntity();

    expect(entity.id, model.id);
    expect(entity.name, model.name);
    expect(entity.createdAt, model.createdAt);
    expect(entity.updatedAt, model.updatedAt);
  });

  test('make sure toEntity() function returns a UnitEntity', () {
    final model = UnitModel(
      id: 'abcd12345',
      siteId: '12345abcd',
      name: 'some place',
      createdAt: now,
      updatedAt: now,
    );

    expect(model.toEntity(), isA<UnitEntity>());
  });

  // TODO: Test team should create a mocking test for the fromRow() function 
}