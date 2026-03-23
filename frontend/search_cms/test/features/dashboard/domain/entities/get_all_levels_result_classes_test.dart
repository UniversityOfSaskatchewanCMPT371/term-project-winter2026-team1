/*
Unit tests for get_all_levels_result_classes.

These tests ensure Success and Failure preserve their constructor data
and remain usable through the shared Result base type.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/features/dashboard/domain/entities/get_all_levels_result_classes.dart'
as get_all_levels_result_classes;
import 'package:search_cms/features/dashboard/domain/entities/level_entity.dart';

void main() {
  group('Success', () {
    test('GET-ALL-LEVELS-RESULT-1-stores the provided listOfLevelEntity', () {
      final listOfLevelEntity = <LevelEntity>[
        LevelEntity(
          id: 'level-1',
          unitId: 'unit-1',
          parentId: null,
          name: 'Level One',
          levelChar: 'A',
          levelInt: 1,
          upLimit: 0,
          lowLimit: 0,
          createdAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
          updatedAt: DateTime.parse('2026-01-02T00:00:00.000Z'),
        ),
        LevelEntity(
          id: 'level-2',
          unitId: 'unit-2',
          parentId: 'level-1',
          name: 'Level Two',
          levelChar: 'B',
          levelInt: 2,
          upLimit: 1,
          lowLimit: 1,
          createdAt: DateTime.parse('2026-02-01T00:00:00.000Z'),
          updatedAt: DateTime.parse('2026-02-02T00:00:00.000Z'),
        ),
      ];

      final result = get_all_levels_result_classes.Success(
        listOfLevelEntity: listOfLevelEntity,
      );

      expect(result, isA<Result>());
      expect(result.listOfLevelEntity, same(listOfLevelEntity));
      expect(result.listOfLevelEntity, hasLength(2));
      expect(result.listOfLevelEntity[0].id, 'level-1');
      expect(result.listOfLevelEntity[0].name, 'Level One');
      expect(result.listOfLevelEntity[1].id, 'level-2');
      expect(result.listOfLevelEntity[1].name, 'Level Two');
    });

    test('GET-ALL-LEVELS-RESULT-2-stores an empty listOfLevelEntity', () {
      final result = get_all_levels_result_classes.Success(
        listOfLevelEntity: <LevelEntity>[],
      );

      expect(result, isA<Result>());
      expect(result.listOfLevelEntity, isEmpty);
    });
  });

  group('Failure', () {
    test('GET-ALL-LEVELS-RESULT-3-stores the provided errorMessage', () {
      final result = get_all_levels_result_classes.Failure(
        errorMessage: 'Something went wrong',
      );

      expect(result, isA<Result>());
      expect(result.errorMessage, 'Something went wrong');
    });

    test('GET-ALL-LEVELS-RESULT-4-stores an empty errorMessage', () {
      final result = get_all_levels_result_classes.Failure(
        errorMessage: '',
      );

      expect(result, isA<Result>());
      expect(result.errorMessage, '');
    });
  });
}