/*
Unit tests for get_all_sites_result_classes.

These tests ensure Success and Failure preserve their constructor data
and remain usable through the shared Result base type.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/features/dashboard/domain/entities/get_all_sites_result_classes.dart'
as get_all_sites_result_classes;
import 'package:search_cms/features/dashboard/domain/entities/site_entity.dart';

void main() {
  group('Success', () {
    test('GET-ALL-SITES-RESULT-1-stores the provided listOfSiteEntity', () {
      final listOfSiteEntity = <SiteEntity>[
        SiteEntity(
          id: 'site-1',
          name: 'Alpha Site',
          borden: 'BORD001',
          createdAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
          updatedAt: DateTime.parse('2026-01-02T00:00:00.000Z'),
        ),
        SiteEntity(
          id: 'site-2',
          name: '',
          borden: 'BORD002',
          createdAt: DateTime.parse('2026-02-01T00:00:00.000Z'),
          updatedAt: DateTime.parse('2026-02-02T00:00:00.000Z'),
        ),
      ];

      final result = get_all_sites_result_classes.Success(
        listOfSiteEntity: listOfSiteEntity,
      );

      expect(result, isA<Result>());
      expect(result.listOfSiteEntity, same(listOfSiteEntity));
      expect(result.listOfSiteEntity, hasLength(2));
      expect(result.listOfSiteEntity[0].id, 'site-1');
      expect(result.listOfSiteEntity[0].name, 'Alpha Site');
      expect(result.listOfSiteEntity[1].id, 'site-2');
      expect(result.listOfSiteEntity[1].name, '');
    });

    test('GET-ALL-SITES-RESULT-2-stores an empty listOfSiteEntity', () {
      final result = get_all_sites_result_classes.Success(
        listOfSiteEntity: <SiteEntity>[],
      );

      expect(result, isA<Result>());
      expect(result.listOfSiteEntity, isEmpty);
    });
  });

  group('Failure', () {
    test('GET-ALL-SITES-RESULT-3-stores the provided errorMessage', () {
      final result = get_all_sites_result_classes.Failure(
        errorMessage: 'Something went wrong',
      );

      expect(result, isA<Result>());
      expect(result.errorMessage, 'Something went wrong');
    });

    test('GET-ALL-SITES-RESULT-4-stores an empty errorMessage', () {
      final result = get_all_sites_result_classes.Failure(
        errorMessage: '',
      );

      expect(result, isA<Result>());
      expect(result.errorMessage, '');
    });
  });
}