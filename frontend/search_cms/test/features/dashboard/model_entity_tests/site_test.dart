import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/dashboard/data/models/site_model.dart';
import 'package:search_cms/features/dashboard/domain/entities/site_entity.dart';

void main() {

  final DateTime now = DateTime.now();


  // SiteEntity tests
  // General test case
  test('create entity with valid inputs', () {
    final SiteEntity entity = SiteEntity(
      id: 'abcd12345',
      name: 'some site',
      borden: '123456',
      createdAt: now,
      updatedAt: now,
    );

    expect(entity.id, 'abcd12345');
    expect(entity.name, 'some site');
    expect(entity.borden, '123456');
    expect(entity.createdAt, now);
    expect(entity.updatedAt, now);
  });

  // Check if there can be an empty name from the db
  test('create entity with empty name', () {
    final SiteEntity entity = SiteEntity(
      id: 'abcd12345',
      name: '',
      borden: '123456',
      createdAt: now,
      updatedAt: now,
    );

    expect(entity.name, '');
  });

  // Test the assertions in site_entity.dart
  test('will throw AssertionError if id is empty', () {
    expect(() => SiteEntity(id: '', name: 'some site', borden: '123456', createdAt: now, updatedAt: now),
      throwsA(isA<AssertionError>()));
  });

  test('will throw AssertionError if borden is empty', () {
    expect(() => SiteEntity(id: 'abcd12345', name: 'some site', borden: '', createdAt: now, updatedAt: now),
      throwsA(isA<AssertionError>()));
  });

  test('will throw AssertionError if borden is more than 8 characters', () {
    expect(() => SiteEntity(id: 'abcd12345', name: 'some site', borden: '123456789', createdAt: now, updatedAt: now),
      throwsA(isA<AssertionError>()));
  });

  // We could later separate these groups of tests (model and entity) into different dirs/files

  // SiteModel tests
  // General test case
  test('create model with valid inputs', () {
    final SiteModel model = SiteModel(
      id: 'abcd12345',
      name: 'some site',
      borden: '123456',
      createdAt: now,
      updatedAt: now,
    );

    expect(model.id, 'abcd12345');
    expect(model.name, 'some site');
    expect(model.borden, '123456');
    expect(model.createdAt, now);
    expect(model.updatedAt, now);
  });

  // check if name is null
  test('create model with null name', () {
    final SiteModel model = SiteModel(
      id: 'abcd12345',
      name: null,
      borden: '123456',
      createdAt: now,
      updatedAt: now,
    );

    expect(model.name, null);
  });

  // Test the toEntity() function
  test('toEntity() should return SiteEntity with same values it had before conversion', () {
    final SiteModel model = SiteModel(
      id: 'abcd12345',
      name: 'some site',
      borden: '123456',
      createdAt: now,
      updatedAt: now,
    );
    final SiteEntity entity = model.toEntity();

    expect(entity.id, model.id);
    expect(entity.name, model.name);
    expect(entity.borden, model.borden);
    expect(entity.createdAt, model.createdAt);
    expect(entity.updatedAt, model.updatedAt);
  });


  test('make sure toEntity() function returns a SiteEntity', () {
    final SiteModel model = SiteModel(
      id: 'abcd12345',
      name: 'some site',
      borden: '123456',
      createdAt: now,
      updatedAt: now,
    );

    expect(model.toEntity(), isA<SiteEntity>());
  });

  // Test team could create a mocking test for the fromRow() function
}