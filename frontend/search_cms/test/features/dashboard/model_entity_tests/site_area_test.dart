import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/dashboard/data/models/site_area_model.dart';
import 'package:search_cms/features/dashboard/domain/entities/site_area_entity.dart';

void main() {
  // Tests site_area_entity
  // General case
  test('create entity with valid inputs', () {
    final entity = SiteAreaEntity(
      id: '67890wxyz',
      siteId: 'abcd12345',
      areaId: '12345abcd',
    );

    expect(entity.id, '67890wxyz');
    expect(entity.siteId, 'abcd12345');
    expect(entity.areaId, '12345abcd');
  });

  // Test assertions from site_area_entity.dart
  test('will throw AssertionError if id is empty', () {
    expect(() => SiteAreaEntity(id: '', siteId: 'abcd12345', areaId: '12345abcd'),
      throwsA(isA<AssertionError>()));
  });

  test('will throw AssertionError if siteId is empty', () {
    expect(() => SiteAreaEntity(id: '67890wxyz', siteId: '', areaId: '12345abcd'),
      throwsA(isA<AssertionError>()));
  });

  test('will throw AssertionError if areaId is empty', () {
    expect(() => SiteAreaEntity(id: '67890wxyz', siteId: 'abcd12345', areaId: ''),
      throwsA(isA<AssertionError>()));
  });

  // Tests site_area_model
  // General test case
  test('create SiteAreaModel with valid inputs', () {
    final model = SiteAreaModel(
      id: '67890wxyz',
      siteId: 'abcd12345',
      areaId: '12345abcd',
    );
    expect(model.id, '67890wxyz');
    expect(model.siteId, 'abcd12345');
    expect(model.areaId, '12345abcd');
  });

  // Tests toEntity() function
  test('toEntity() should return SiteAreaEntity with same values it had before conversion', () {
    final model = SiteAreaModel(
      id: '67890wxyz',
      siteId: 'abcd12345',
      areaId: '12345abcd',
    );

    final SiteAreaEntity entity = model.toEntity();

    expect(entity.id, model.id);
    expect(entity.siteId, model.siteId);
    expect(entity.areaId, model.areaId);
  });

  test('make sure toEntity() function returns a SiteAreaEntity', () {
    final model = SiteAreaModel(
      id: '67890wxyz',
      siteId: 'abcd12345',
      areaId: '12345abcd',
    );

    expect(model.toEntity(), isA<SiteAreaEntity>());
  });
}

