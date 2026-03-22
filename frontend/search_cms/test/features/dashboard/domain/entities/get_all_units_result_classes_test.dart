/*
Unit tests for get_all_units_result_classes.

These tests ensure Success and Failure preserve their constructor data
and remain usable through the shared Result base type.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/features/dashboard/domain/entities/get_all_units_result_classes.dart'
as get_all_units_result_classes;
import 'package:search_cms/features/dashboard/domain/entities/unit_entity.dart';

void main() {
  group('Success', () {
    test('stores the provided listOfUnitEntity', () {
      final listOfUnitEntity = <UnitEntity>[
        UnitEntity(
          id: 'unit-1',
          siteId: 'site-1',
          name: 'Alpha Unit',
          createdAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
          updatedAt: DateTime.parse('2026-01-02T00:00:00.000Z'),
        ),
        UnitEntity(
          id: 'unit-2',
          siteId: 'site-2',
          name: 'Beta Unit',
          createdAt: DateTime.parse('2026-02-01T00:00:00.000Z'),
          updatedAt: DateTime.parse('2026-02-02T00:00:00.000Z'),
        ),
      ];

      final result = get_all_units_result_classes.Success(
        listOfUnitEntity: listOfUnitEntity,
      );

      expect(result, isA<Result>());
      expect(result.listOfUnitEntity, same(listOfUnitEntity));
      expect(result.listOfUnitEntity, hasLength(2));
      expect(result.listOfUnitEntity[0].id, 'unit-1');
      expect(result.listOfUnitEntity[0].name, 'Alpha Unit');
      expect(result.listOfUnitEntity[1].id, 'unit-2');
      expect(result.listOfUnitEntity[1].name, 'Beta Unit');
    });

    test('stores an empty listOfUnitEntity', () {
      final result = get_all_units_result_classes.Success(
        listOfUnitEntity: <UnitEntity>[],
      );

      expect(result, isA<Result>());
      expect(result.listOfUnitEntity, isEmpty);
    });
  });

  group('Failure', () {
    test('stores the provided errorMessage', () {
      final result = get_all_units_result_classes.Failure(
        errorMessage: 'Something went wrong',
      );

      expect(result, isA<Result>());
      expect(result.errorMessage, 'Something went wrong');
    });

    test('stores an empty errorMessage', () {
      final result = get_all_units_result_classes.Failure(
        errorMessage: '',
      );

      expect(result, isA<Result>());
      expect(result.errorMessage, '');
    });
  });
}