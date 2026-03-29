import 'package:glados/glados.dart';
import 'package:search_cms/features/dashboard/data/models/table_row_model.dart';
import 'package:search_cms/features/dashboard/domain/entities/table_row_entity.dart';

import '../../../pbt_utils/pbt_utils.dart';

// Generates a TableRowEntity with random values that satisfy all invariants
// call with 'tableRowEntity'
extension AnyTableRowEntity on Any {
  Generator<TableRowEntity> get tableRowEntity => combine10(
    StringAnys(any).nonEmptyLetters,          // borden
    StringAnys(any).nonEmptyLetters,          // areaName
    StringAnys(any).nonEmptyLetters,          // unitName
    StringAnys(any).nonEmptyLetters,          // levelName
    any.validLimitRange,                      // [upLimit, lowLimit]: 0 pair or valid ordered pair
    any.letters,                              // assemblageName: string or empty, never null (entity requires String)
    any.nullablePorosity,                     // porosity: null or int between 1-5
    any.nullableValidSizeRange,               // [sizeUpper, sizeLower]: null pair or valid ordered pair
    any.letters,                              // comment: string or empty, never null (entity requires String)
    any.validTripleRange,                     // [preExcavFrags, postExcavFrags, elements]: all > 0 pair
    (borden, areaName, unitName, levelName, limitPair, assemblageName, porosity, sizePair, comment, triplet) {
      return TableRowEntity(
        borden: borden, 
        siteName: '', // Over limit. borden is more important, so we can assume siteName is always empty
        areaName: areaName, 
        unitName: unitName, 
        levelName: levelName, 
        upLimit: limitPair[0], 
        lowLimit: limitPair[1], 
        assemblageName: assemblageName,
        porosity: porosity,
        sizeUpper: sizePair[0],
        sizeLower: sizePair[1], 
        comment: comment, 
        preExcavFrags: triplet[0], 
        postExcavFrags: triplet[1], 
        elements: triplet[2],
      );
    }
  );
}

// Generates a TableRowModel with random values
// call with 'tableRowModel'
extension AnyTableRowModel on Any {
  Generator<TableRowModel> get tableRowModel => combine10(
    StringAnys(any).nonEmptyLetters,          // borden
    StringAnys(any).nonEmptyLetters,          // areaName
    StringAnys(any).nonEmptyLetters,          // unitName
    StringAnys(any).nonEmptyLetters,          // levelName
    any.validLimitRange,                      // [upLimit, lowLimit]: 0 pair or valid ordered pair
    any.letters,                              // assemblageName: string or empty, never null (entity requires String)
    any.nullablePorosity,                     // porosity: null or int between 1-5
    any.nullableValidSizeRange,               // [sizeUpper, sizeLower]: null pair or valid ordered pair
    any.letters,                              // comment: string or empty, never null (entity requires String)
    any.validTripleRange,                     // [preExcavFrags, postExcavFrags, elements]: all > 0 pair
    (borden, areaName, unitName, levelName, limitPair, assemblageName, porosity, sizePair, comment, triplet) {
      return TableRowModel(
        borden: borden, 
        siteName: '', // Over limit. borden is more important, so we can safely assume siteName is always empty
        areaName: areaName, 
        unitName: unitName, 
        levelName: levelName, 
        upLimit: limitPair[0], 
        lowLimit: limitPair[1], 
        assemblageName: assemblageName,
        porosity: porosity,
        sizeUpper: sizePair[0],
        sizeLower: sizePair[1], 
        comment: comment, 
        preExcavFrags: triplet[0], 
        postExcavFrags: triplet[1], 
        elements: triplet[2],
      );
    }
  );
}

// Runs randomized property-based tests on the TableRowEntity and TableRowModel class
// This tests the invariants of the entity against generated Glados instances
// The unit tests already cover the edge cases where required fields are empty or
// constrained fields are out of range, so this test does not attempt to target those

void main() { 
  group('TABLE-ROW-PBT: Entity and Model PBT Tests', () {

    /*** Test 1 - TableRowEntity ***/
    // Creates a randomly generated entity and verifies its contents
    Any.setDefault<TableRowEntity>(any.tableRowEntity);

    Glados<TableRowEntity>().test(
      'generated TableRowEntity has valid fields', 
      (tableRowEntity) {

        // borden must always be a valid string
        expect(tableRowEntity.borden, isA<String>());

        // siteName is always a String (never null) on the entity
        expect(tableRowEntity.siteName, isA<String>());

        // areaName must always be a valid string
        expect(tableRowEntity.areaName, isA<String>());

        // unitName must always be a valid string
        expect(tableRowEntity.unitName, isA<String>());

        // levelName must always be a valid string
        expect(tableRowEntity.levelName, isA<String>());

        // upLimit <= lowLimit when both are present
        expect(tableRowEntity.upLimit, lessThanOrEqualTo(tableRowEntity.lowLimit));

        // assemblageName is always a String (never null) on the entity
        expect(tableRowEntity.assemblageName, isA<String>());

        // porosity must be null or between 1-5
        if (tableRowEntity.porosity != null) {
          expect(tableRowEntity.porosity, greaterThanOrEqualTo(1));
          expect(tableRowEntity.porosity, lessThanOrEqualTo(5));
        }
 
        // sizeUpper >= sizeLower when both are present
        if (tableRowEntity.sizeUpper != null && tableRowEntity.sizeLower != null) {
          expect(tableRowEntity.sizeUpper, greaterThanOrEqualTo(tableRowEntity.sizeLower!));
        }
 
        // comment is always a String (never null) on the entity
        expect(tableRowEntity.comment, isA<String>());

        // fragment and element counts must all be > 0
        expect(tableRowEntity.preExcavFrags, greaterThan(0));
        expect(tableRowEntity.postExcavFrags, greaterThan(0));
        expect(tableRowEntity.elements, greaterThan(0));
      });
  });
}



