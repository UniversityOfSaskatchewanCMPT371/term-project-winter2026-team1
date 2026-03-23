/*
Unit tests for get_all_areas_result_classes.

These tests ensure Success and Failure preserve their constructor data
and remain usable through the shared Result base type.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/features/dashboard/domain/entities/area_entity.dart';
import 'package:search_cms/features/dashboard/domain/entities/get_all_areas_result_classes.dart'
as get_all_areas_result_classes;

void main() {
  group('Success', () {
    test('stores the provided listOfAreaEntity', () {
      final listOfAreaEntity = <AreaEntity>[
        AreaEntity(
          id: 'area-1',
          name: 'Alpha Area',
          createdAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
          updatedAt: DateTime.parse('2026-01-02T00:00:00.000Z'),
        ),
        AreaEntity(
          id: 'area-2',
          name: 'Beta Area',
          createdAt: DateTime.parse('2026-02-01T00:00:00.000Z'),
          updatedAt: DateTime.parse('2026-02-02T00:00:00.000Z'),
        ),
      ];

      final result = get_all_areas_result_classes.Success(
        listOfAreaEntity: listOfAreaEntity,
      );

      expect(result, isA<Result>());
      expect(result.listOfAreaEntity, same(listOfAreaEntity));
      expect(result.listOfAreaEntity, hasLength(2));
      expect(result.listOfAreaEntity[0].id, 'area-1');
      expect(result.listOfAreaEntity[0].name, 'Alpha Area');
      expect(result.listOfAreaEntity[1].id, 'area-2');
      expect(result.listOfAreaEntity[1].name, 'Beta Area');
    });

    test('stores an empty listOfAreaEntity', () {
      final result = get_all_areas_result_classes.Success(
        listOfAreaEntity: <AreaEntity>[],
      );

      expect(result, isA<Result>());
      expect(result.listOfAreaEntity, isEmpty);
    });
  });

  group('Failure', () {
    test('stores the provided errorMessage', () {
      final result = get_all_areas_result_classes.Failure(
        errorMessage: 'Something went wrong',
      );

      expect(result, isA<Result>());
      expect(result.errorMessage, 'Something went wrong');
    });

    test('stores an empty errorMessage', () {
      final result = get_all_areas_result_classes.Failure(
        errorMessage: '',
      );

      expect(result, isA<Result>());
      expect(result.errorMessage, '');
    });
  });
}