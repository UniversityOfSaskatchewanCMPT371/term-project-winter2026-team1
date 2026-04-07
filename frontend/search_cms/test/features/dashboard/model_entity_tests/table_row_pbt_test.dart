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
    any.validLimitRangeString,                // [upLimit, lowLimit]: 0 pair or valid ordered pair
    any.letters,                              // assemblageName: string or empty, never null (entity requires String)
    any.nullablePorosityString,               // porosity: null or int between 1-5
    any.nullableValidSizeRangeString,         // [sizeUpper, sizeLower]: null pair or valid ordered pair
    any.letters,                              // comment: string or empty, never null (entity requires String)
    any.validTripleRangeString,               // [preExcavFrags, postExcavFrags, elements]: all > 0 pair
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
    any.letters,                              // borden (entity requires String, model allows null)
    any.letters,                              // areaName (entity requires String, model allows null)
    any.letters,                              // unitName (entity requires String, model allows null)
    any.letters,                              // levelName (entity requires String, model allows null)
    any.validLimitRangeString,                // [upLimit, lowLimit]: 0 pair or valid ordered pair
    any.letters,                              // assemblageName: string or empty, never null (entity requires String, model allows null)
    any.nullablePorosityString,               // porosity: null or int between 1-5
    any.nullableValidSizeRangeString,         // [sizeUpper, sizeLower]: null pair or valid ordered pair
    any.letters,                              // comment: string or empty, never null (entity requires String, model allows null)
    any.validTripleRangeString,               // [preExcavFrags, postExcavFrags, elements]: all > 0 pair
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
        expect(int.parse(tableRowEntity.upLimit), lessThanOrEqualTo(int.parse(tableRowEntity.lowLimit)));

        // assemblageName is always a String (never null) on the entity
        expect(tableRowEntity.assemblageName, isA<String>());

        // porosity must be null or between 1-5
        if (tableRowEntity.porosity != null) {
          expect(int.parse(tableRowEntity.porosity!), greaterThanOrEqualTo(1));
          expect(int.parse(tableRowEntity.porosity!), lessThanOrEqualTo(5));
        }
 
        // sizeUpper >= sizeLower when both are present
        if (tableRowEntity.sizeUpper != null && tableRowEntity.sizeLower != null) {
          expect(double.parse(tableRowEntity.sizeUpper!), greaterThanOrEqualTo(double.parse(tableRowEntity.sizeLower!)));
        }
 
        // comment is always a String (never null) on the entity
        expect(tableRowEntity.comment, isA<String>());

        // fragment and element counts must all be > 0
        expect(int.parse(tableRowEntity.preExcavFrags), greaterThan(0));
        expect(int.parse(tableRowEntity.postExcavFrags), greaterThan(0));
        expect(int.parse(tableRowEntity.elements), greaterThan(0));
      });

    /*** Test 2 - TableRowModel ***/
    // Creates a randomly generated model and verifies its contents
    Any.setDefault<TableRowModel>(any.tableRowModel);

    Glados<TableRowModel>().test(
      'generated TableRowModel has valid fields', 
      (tableRowModel) {

        // borden is nullable on the model
        if (tableRowModel.borden != null) {
          expect(tableRowModel.borden, isA<String>());
        }

        // siteName is nullable on the model
        if (tableRowModel.siteName != null) {
          expect(tableRowModel.siteName, isA<String>());
        }

        // areaName is nullable on the model
        if (tableRowModel.areaName != null) {
          expect(tableRowModel.areaName, isA<String>());
        }

        // unitName is nullable on the model
        if (tableRowModel.unitName != null) {
          expect(tableRowModel.unitName, isA<String>());
        }

        // levelName is nullable on the model
        if (tableRowModel.levelName != null) {
          expect(tableRowModel.levelName, isA<String>());
        }

        // upLimit <= lowLimit when both are present; nullable on the model
        expect(int.parse(tableRowModel.upLimit!), lessThanOrEqualTo(int.parse(tableRowModel.lowLimit!)));

        // assemblageName is nullable on the model
        if (tableRowModel.assemblageName != null) {
          expect(tableRowModel.assemblageName, isA<String>());
        }

        // porosity must be null or between 1-5
        if (tableRowModel.porosity != null) {
          expect(int.parse(tableRowModel.porosity!), greaterThanOrEqualTo(1));
          expect(int.parse(tableRowModel.porosity!), lessThanOrEqualTo(5));
        }
 
        // sizeUpper >= sizeLower when both are present
        if (tableRowModel.sizeUpper != null && tableRowModel.sizeLower != null) {
          expect(double.parse(tableRowModel.sizeUpper!), greaterThanOrEqualTo(double.parse(tableRowModel.sizeLower!)));
        }
 
        // comment is nullable on the model
        if (tableRowModel.comment != null) {
          expect(tableRowModel.comment, isA<String>());
        }

        // fragment and element counts must all be > 0; nullable on the model
        expect(int.parse(tableRowModel.preExcavFrags!), greaterThan(0));
        expect(int.parse(tableRowModel.postExcavFrags!), greaterThan(0));
        expect(int.parse(tableRowModel.elements!), greaterThan(0));
      });

    /*** Test 3 - toEntity() ***/
    // Ensures any model, when converted to an entity, will be both
    // a valid entity and will carry the same values as the model
    Glados<TableRowModel>().test(
      'toEntity() returns a valid TableRowEntity with the same values', 
      (tableRowModel) {

        final entity = tableRowModel.toEntity();

        // Entity is the correct type
        expect(entity, isA<TableRowEntity>());

        // If model.borden is null it gets converted to empty string in toEntity()
        if (tableRowModel.borden == null) {
          expect(entity.borden, isEmpty);
        } else {
          expect(entity.borden, tableRowModel.borden);
        }

        // If model.siteName is null it gets converted to empty string in toEntity()
        if (tableRowModel.siteName == null) {
          expect(entity.siteName, isEmpty);
        } else {
          expect(entity.siteName, tableRowModel.siteName);
        }

        // If model.areaName is null it gets converted to empty string in toEntity()
        if (tableRowModel.areaName == null) {
          expect(entity.areaName, isEmpty);
        } else {
          expect(entity.areaName, tableRowModel.areaName);
        }

        // If model.unitName is null it gets converted to empty string in toEntity()
        if (tableRowModel.unitName == null) {
          expect(entity.unitName, isEmpty);
        } else {
          expect(entity.unitName, tableRowModel.unitName);
        }

        // If model.levelName is null it gets converted to empty string in toEntity()
        if (tableRowModel.levelName == null) {
          expect(entity.levelName, isEmpty);
        } else {
          expect(entity.levelName, tableRowModel.levelName);
        }

        // Always generated, no null check needed
        expect(entity.upLimit, tableRowModel.upLimit);
        expect(entity.lowLimit, tableRowModel.lowLimit);

        // If model.assemblageName is null it gets converted to empty string in toEntity()
        if (tableRowModel.assemblageName == null) {
          expect(entity.assemblageName, isEmpty);
        } else {
          expect(entity.assemblageName, tableRowModel.assemblageName);
        }

        // Both model and entity are nullable, no check needed
        expect(entity.porosity, tableRowModel.porosity);
        expect(entity.sizeUpper, tableRowModel.sizeUpper);
        expect(entity.sizeLower, tableRowModel.sizeLower);
        
        // If model.comment is null it gets converted to empty string in toEntity()
        if (tableRowModel.comment == null) {
          expect(entity.comment, isEmpty);
        } else {
          expect(entity.comment, tableRowModel.comment);
        }

        // Always generated, no null check needed
        expect(entity.preExcavFrags, tableRowModel.preExcavFrags);
        expect(entity.postExcavFrags, tableRowModel.postExcavFrags);
        expect(entity.elements, tableRowModel.elements);
      });
  });
}





