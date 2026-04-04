import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/dashboard/data/models/table_row_model.dart';
import 'package:search_cms/features/dashboard/domain/entities/table_row_entity.dart';

void main() {

  /********************************************** TableRowEntity Tests **********************************************/

  // Test Case 1: General Test Case
  test('Create entity with valid inputs', () {
    final TableRowEntity entity = TableRowEntity(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: '1',
      lowLimit: '5',
      assemblageName: 'A1 Faunal Assemblage',
      porosity: '3',
      sizeUpper: '3',
      sizeLower: '2',
      comment: 'Bone',
      preExcavFrags: '1',
      postExcavFrags: '1',
      elements: '1',
    );

    expect(entity.borden, 'DiRx-28');
    expect(entity.siteName, 'Site');
    expect(entity.areaName, 'Western End of Slope');
    expect(entity.unitName, 'N84SW1');
    expect(entity.levelName, 'A1');
    expect(entity.upLimit, '1');
    expect(entity.lowLimit, '5');
    expect(entity.assemblageName, 'A1 Faunal Assemblage');
    expect(entity.porosity, '3');
    expect(entity.sizeUpper, '3');
    expect(entity.sizeLower, '2');
    expect(entity.comment, 'Bone');
    expect(entity.preExcavFrags, '1');
    expect(entity.postExcavFrags, '1');
    expect(entity.elements, '1');
  });

  /*-----------------------------------------------------------------*/

  // Test Case 2: Test with Empty Columns
  test('Create entity with empty inputs', () {
    final TableRowEntity entity = TableRowEntity(
      borden: 'DiRx-28',
      siteName: '',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: '1',
      lowLimit: '5',
      assemblageName: '',
      porosity: null,
      sizeUpper: null,
      sizeLower: null,
      comment: '',
      preExcavFrags: '1',
      postExcavFrags: '1',
      elements: '1',
    );

    expect(entity.borden, 'DiRx-28');
    expect(entity.siteName, '');
    expect(entity.areaName, 'Western End of Slope');
    expect(entity.unitName, 'N84SW1');
    expect(entity.levelName, 'A1');
    expect(entity.upLimit, '1');
    expect(entity.lowLimit, '5');
    expect(entity.assemblageName, '');
    expect(entity.porosity, null);
    expect(entity.sizeUpper, null);
    expect(entity.sizeLower, null);
    expect(entity.comment, '');
    expect(entity.preExcavFrags, '1');
    expect(entity.postExcavFrags, '1');
    expect(entity.elements, '1');
  });

  /*-----------------------------------------------------------------*/

  // Test Case 3: Test Assertions

  // 3(a): upLimit >= lowLimit
  test('Will throw an AssertionError if upLimit >= lowLimit', () {
    expect(() => TableRowEntity(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: '10',
      lowLimit: '5',
      assemblageName: 'A1 Faunal Assemblage',
      porosity: '3',
      sizeUpper: '3',
      sizeLower: '2',
      comment: 'Bone',
      preExcavFrags: '1',
      postExcavFrags: '1',
      elements: '1'),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(b): porosity < 1
  test('Will throw an AssertionError if porosity < 1', () {
    expect(() => TableRowEntity(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: '1',
      lowLimit: '5',
      assemblageName: 'A1 Faunal Assemblage',
      porosity: '0',
      sizeUpper: '3',
      sizeLower: '2',
      comment: 'Bone',
      preExcavFrags: '1',
      postExcavFrags: '1',
      elements: '1'),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(c): porosity > 5
  test('Will throw an AssertionError if porosity > 5', () {
    expect(() => TableRowEntity(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: '1',
      lowLimit: '5',
      assemblageName: 'A1 Faunal Assemblage',
      porosity: '6',
      sizeUpper: '3',
      sizeLower: '2',
      comment: 'Bone',
      preExcavFrags: '1',
      postExcavFrags: '1',
      elements: '1'),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(d): sizeUpper < sizeLower
  test('Will throw an AssertionError if sizeUpper < sizeLower', () {
    expect(() => TableRowEntity(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: '1',
      lowLimit: '5',
      assemblageName: 'A1 Faunal Assemblage',
      porosity: '3',
      sizeUpper: '1',
      sizeLower: '5',
      comment: 'Bone',
      preExcavFrags: '1',
      postExcavFrags: '1',
      elements: '1'),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(e): preExcavFrags, postExcavFrags, elements < 1
  test('Will throw an AssertionError if preExcavFrags, postExcavFrags, elements < 1', () {
    expect(() => TableRowEntity(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: '1',
      lowLimit: '5',
      assemblageName: 'A1 Faunal Assemblage',
      porosity: '3',
      sizeUpper: '3',
      sizeLower: '2',
      comment: 'Bone',
      preExcavFrags: '0',
      postExcavFrags: '0',
      elements: '0'),
        throwsA(isA<AssertionError>())
    );
  });

  /*-----------------------------------------------------------------*/

  /********************************************** TableRowModel Tests ***********************************************/

  // Test Case 4: General Test Case

  test('Create model with valid inputs', () {
    final TableRowModel model = TableRowModel(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: '1',
      lowLimit: '5',
      assemblageName: 'A1 Faunal Assemblage',
      porosity: '3',
      sizeUpper: '3',
      sizeLower: '2',
      comment: 'Bone',
      preExcavFrags: '1',
      postExcavFrags: '1',
      elements: '1',
    );

    expect(model.borden, 'DiRx-28');
    expect(model.siteName, 'Site');
    expect(model.areaName, 'Western End of Slope');
    expect(model.unitName, 'N84SW1');
    expect(model.levelName, 'A1');
    expect(model.upLimit, '1');
    expect(model.lowLimit, '5');
    expect(model.assemblageName, 'A1 Faunal Assemblage');
    expect(model.porosity, '3');
    expect(model.sizeUpper, '3');
    expect(model.sizeLower, '2');
    expect(model.comment, 'Bone');
    expect(model.preExcavFrags, '1');
    expect(model.postExcavFrags, '1');
    expect(model.elements, '1');
  });

  /*-----------------------------------------------------------------*/

  // Test Case 5: Test toEntity() Function

  // 5(a): Return TableRowEntity with Same Values
  test('toEntity() should return TableRowEntity with same values it had before conversion', () {
    final TableRowModel model = TableRowModel(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: '1',
      lowLimit: '5',
      assemblageName: 'A1 Faunal Assemblage',
      porosity: '3',
      sizeUpper: '3',
      sizeLower: '2',
      comment: 'Bone',
      preExcavFrags: '1',
      postExcavFrags: '1',
      elements: '1',
    );

    final TableRowEntity entity = model.toEntity();

    expect(model.borden, entity.borden);
    expect(model.siteName, entity.siteName);
    expect(model.areaName, entity.areaName);
    expect(model.unitName, entity.unitName);
    expect(model.levelName, entity.levelName);
    expect(model.upLimit, entity.upLimit);
    expect(model.lowLimit, entity.lowLimit);
    expect(model.assemblageName, entity.assemblageName);
    expect(model.porosity, entity.porosity);
    expect(model.sizeUpper, entity.sizeUpper);
    expect(model.sizeLower, entity.sizeLower);
    expect(model.comment, entity.comment);
    expect(model.preExcavFrags, entity.preExcavFrags);
    expect(model.postExcavFrags, entity.postExcavFrags);
    expect(model.elements, entity.elements);
  });

  // 5(b): Ensure toEntity() Returns a TableRowEntity
  test('Ensure toEntity() funtion returns an TableRowEntity', () {
    final TableRowModel model = TableRowModel(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: '1',
      lowLimit: '5',
      assemblageName: 'A1 Faunal Assemblage',
      porosity: '3',
      sizeUpper: '3',
      sizeLower: '2',
      comment: 'Bone',
      preExcavFrags: '1',
      postExcavFrags: '1',
      elements: '1',
    );

    expect(model.toEntity(), isA<TableRowEntity>());

  });
}
