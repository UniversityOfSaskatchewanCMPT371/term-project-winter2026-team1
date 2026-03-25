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
      upLimit: 1,
      lowLimit: 5,
      assemblageName: 'A1 Faunal Assemblage',
      porosity: 3,
      sizeUpper: 3,
      sizeLower: 2,
      comment: 'Bone',
      preExcavFrags: 1,
      postExcavFrags: 1,
      elements: 1,
    );

    expect(entity.borden, 'DiRx-28');
    expect(entity.siteName, 'Site');
    expect(entity.areaName, 'Western End of Slope');
    expect(entity.unitName, 'N84SW1');
    expect(entity.levelName, 'A1');
    expect(entity.upLimit, 1);
    expect(entity.lowLimit, 5);
    expect(entity.assemblageName, 'A1 Faunal Assemblage');
    expect(entity.porosity, 3);
    expect(entity.sizeUpper, 3);
    expect(entity.sizeLower, 2);
    expect(entity.comment, 'Bone');
    expect(entity.preExcavFrags, 1);
    expect(entity.postExcavFrags, 1);
    expect(entity.elements, 1);
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
      upLimit: 1,
      lowLimit: 5,
      assemblageName: '',
      porosity: null,
      sizeUpper: null,
      sizeLower: null,
      comment: '',
      preExcavFrags: 1,
      postExcavFrags: 1,
      elements: 1,
    );

    expect(entity.borden, 'DiRx-28');
    expect(entity.siteName, '');
    expect(entity.areaName, 'Western End of Slope');
    expect(entity.unitName, 'N84SW1');
    expect(entity.levelName, 'A1');
    expect(entity.upLimit, 1);
    expect(entity.lowLimit, 5);
    expect(entity.assemblageName, '');
    expect(entity.porosity, null);
    expect(entity.sizeUpper, null);
    expect(entity.sizeLower, null);
    expect(entity.comment, '');
    expect(entity.preExcavFrags, 1);
    expect(entity.postExcavFrags, 1);
    expect(entity.elements, 1);
  });

  /*-----------------------------------------------------------------*/

  // Test Case 3: Test Assertions

  // 3(a): Empty Borden
  test('Will throw an AssertionError if borden is empty', () {
    expect(() => TableRowEntity(
      borden: '',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: 1,
      lowLimit: 5,
      assemblageName: 'A1 Faunal Assemblage',
      porosity: 3,
      sizeUpper: 3,
      sizeLower: 2,
      comment: 'Bone',
      preExcavFrags: 1,
      postExcavFrags: 1,
      elements: 1),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(b): Empty Area Name
  test('Will throw an AssertionError if areaName is empty', () {
    expect(() => TableRowEntity(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: '',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: 1,
      lowLimit: 5,
      assemblageName: 'A1 Faunal Assemblage',
      porosity: 3,
      sizeUpper: 3,
      sizeLower: 2,
      comment: 'Bone',
      preExcavFrags: 1,
      postExcavFrags: 1,
      elements: 1),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(c): Empty Unit Name
  test('Will throw an AssertionError if unitName is empty', () {
    expect(() => TableRowEntity(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: '',
      levelName: 'A1',
      upLimit: 1,
      lowLimit: 5,
      assemblageName: 'A1 Faunal Assemblage',
      porosity: 3,
      sizeUpper: 3,
      sizeLower: 2,
      comment: 'Bone',
      preExcavFrags: 1,
      postExcavFrags: 1,
      elements: 1),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(d): Empty Level Name
  test('Will throw an AssertionError if levelName is empty', () {
    expect(() => TableRowEntity(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: '',
      upLimit: 1,
      lowLimit: 5,
      assemblageName: 'A1 Faunal Assemblage',
      porosity: 3,
      sizeUpper: 3,
      sizeLower: 2,
      comment: 'Bone',
      preExcavFrags: 1,
      postExcavFrags: 1,
      elements: 1),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(e): upLimit >= lowLimit
  test('Will throw an AssertionError if upLimit >= lowLimit', () {
    expect(() => TableRowEntity(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: 10,
      lowLimit: 5,
      assemblageName: 'A1 Faunal Assemblage',
      porosity: 3,
      sizeUpper: 3,
      sizeLower: 2,
      comment: 'Bone',
      preExcavFrags: 1,
      postExcavFrags: 1,
      elements: 1),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(f): porosity < 1
  test('Will throw an AssertionError if porosity < 1', () {
    expect(() => TableRowEntity(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: 1,
      lowLimit: 5,
      assemblageName: 'A1 Faunal Assemblage',
      porosity: 0,
      sizeUpper: 3,
      sizeLower: 2,
      comment: 'Bone',
      preExcavFrags: 1,
      postExcavFrags: 1,
      elements: 1),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(g): porosity > 5
  test('Will throw an AssertionError if porosity > 5', () {
    expect(() => TableRowEntity(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: 1,
      lowLimit: 5,
      assemblageName: 'A1 Faunal Assemblage',
      porosity: 6,
      sizeUpper: 3,
      sizeLower: 2,
      comment: 'Bone',
      preExcavFrags: 1,
      postExcavFrags: 1,
      elements: 1),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(h): sizeUpper < sizeLower
  test('Will throw an AssertionError if sizeUpper < sizeLower', () {
    expect(() => TableRowEntity(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: 1,
      lowLimit: 5,
      assemblageName: 'A1 Faunal Assemblage',
      porosity: 3,
      sizeUpper: 1,
      sizeLower: 5,
      comment: 'Bone',
      preExcavFrags: 1,
      postExcavFrags: 1,
      elements: 1),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(i): preExcavFrags, postExcavFrags, elements < 1
  test('Will throw an AssertionError if preExcavFrags, postExcavFrags, elements < 1', () {
    expect(() => TableRowEntity(
      borden: 'DiRx-28',
      siteName: 'Site',
      areaName: 'Western End of Slope',
      unitName: 'N84SW1',
      levelName: 'A1',
      upLimit: 1,
      lowLimit: 5,
      assemblageName: 'A1 Faunal Assemblage',
      porosity: 3,
      sizeUpper: 3,
      sizeLower: 2,
      comment: 'Bone',
      preExcavFrags: 0,
      postExcavFrags: 0,
      elements: 0),
        throwsA(isA<AssertionError>())
    );
  });

  /*-----------------------------------------------------------------*/

  
}