import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/authentication/data/models/site_area_model.dart';
import 'package:search_cms/features/authentication/domain/entities/site_area_entity.dart';

void main() {
  // tests site_area_entity
  // general case
  test('create entity with valid inputs', () {
    final entity = SiteAreaEntity(
      siteId: 'abcd12345',
      areaId: '12345abcd',
    );

    expect(entity.siteId, 'abcd12345');
    expect(entity.areaId, '12345abcd');
  });

  // test assertions from site_area_entity.dart
  test('will throw AssertionError if siteId is empty', () {
    expect(() => SiteAreaEntity(siteId: '', areaId: '12345abcd'),
      throwsA(isA<AssertionError>()));
  });

  test('will throw AssertionError if areaId is empty', () {
    expect(() => SiteAreaEntity(siteId: 'abcd12345', areaId: ''),
      throwsA(isA<AssertionError>()));
  });

  // tests site_area_model
  // general test case
  test('create SiteAreaModel with valid inputs', () {
    final model = SiteAreaModel(
      siteId: 'abcd12345',
      areaId: '12345abcd',
    );

    expect(model.siteId, 'abcd12345');
    expect(model.areaId, '12345abcd');
  });

  // tests toEntity() function
  test('toEntity() should return SiteAreaEntity with same values it had before conversion', () {
    final model = SiteAreaModel(
      siteId: 'abcd12345',
      areaId: '12345abcd',
    );

    final SiteAreaEntity entity = model.toEntity();

    expect(entity.siteId, model.siteId);
    expect(entity.areaId, model.areaId);
  });

  test('make sure toEntity() function returns a SiteAreaEntity', () {
    final model = SiteAreaModel(
      siteId: 'abcd12345',
      areaId: '12345abcd',
    );

    expect(model.toEntity(), isA<SiteAreaEntity>());
  });
}