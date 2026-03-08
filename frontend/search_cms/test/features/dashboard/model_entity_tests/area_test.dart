import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/dashboard/data/models/area_model.dart';
import 'package:search_cms/features/dashboard/domain/entities/area_entity.dart';
void main() {

  final DateTime now = DateTime.now();


  // AreaEntity tests
  // General test case
  test('create entity wiht valid inputs', () {
    final entity = AreaEntity(
      id: 'abcd12345',
      name: 'some place',
      createdAt: now,
      updatedAt: now,
    );

    expect(entity.id, 'abcd12345');
    expect(entity.name, 'some place');
    expect(entity.createdAt, now);
    expect(entity.updatedAt, now);

  });

  // Test the assertions in area_entity.dart
  test('will throw AssertionError if id is empty', () {
    expect(() => AreaEntity(id: '', name: 'some place', createdAt: now, updatedAt: now),
      throwsA(isA<AssertionError>()));
  });

  test('will throw AssertionError if name is empty', () {
    expect(() => AreaEntity(id: 'abcd12345', name: '', createdAt: now, updatedAt: now),
      throwsA(isA<AssertionError>()));
  });

  // We could later seperate these groups of tests (model and entity) into different dirs/files 

  // AreaModel tests 
  // General test case
  test('create model with valid inputs', () {
    final model = AreaModel(
      id: 'abcd12345',
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
  test('toEntity() should return AreaEntity with same values it had before conversion', () {
    final model = AreaModel(
      id: 'abcd12345',
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

  test('make sure toEntity() function returns a AreaEntity', () {
    final model = AreaModel(
      id: 'abcd12345',
      name: 'some place',
      createdAt: now,
      updatedAt: now,
    );

    expect(model.toEntity(), isA<AreaEntity>());
  });
  // TODO: add tests using mocked sqlite.Row for fromRow()
}