import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/dashboard/data/models/artifact_faunal_model.dart';
import 'package:search_cms/features/dashboard/domain/entities/artifact_faunal_entity.dart';

void main() {

  final DateTime now = DateTime.now();

  /********************************************** ArtifactFaunalEntity Tests **********************************************/

  // Test Case 1: General Test Case
  test('Create entity with valid inputs', () {
    final ArtifactFaunalEntity entity = ArtifactFaunalEntity(
      id: '99999999-9999-9999-9999-999999999999', 
      assemblageId: '88888888-8888-8888-8888-888888888888',
      porosity: 3,
      sizeUpper: 3,
      sizeLower: 2,
      comment: 'Bone',
      preExcavFrags: 1,
      postExcavFrags: 1,
      elements: 1, 
      createdAt: now, 
      updatedAt: now,
    );

    expect(entity.id, '99999999-9999-9999-9999-999999999999');
    expect(entity.assemblageId, '88888888-8888-8888-8888-888888888888');
    expect(entity.porosity, 3);
    expect(entity.sizeUpper, 3);
    expect(entity.sizeLower, 2);
    expect(entity.comment, 'Bone');
    expect(entity.preExcavFrags, 1);
    expect(entity.postExcavFrags, 1);
    expect(entity.elements, 1);
    expect(entity.createdAt, now);
    expect(entity.updatedAt, now);
  });

  /*-----------------------------------------------------------------*/

  // Test Case 2: Test with Empty Columns
  test('Create entity with empty inputs', () {
    final ArtifactFaunalEntity entity = ArtifactFaunalEntity(
      id: '99999999-9999-9999-9999-999999999999', 
      assemblageId: '88888888-8888-8888-8888-888888888888',
      porosity: null,
      sizeUpper: null,
      sizeLower: null,
      comment: '',
      preExcavFrags: 1,
      postExcavFrags: 1,
      elements: 1, 
      createdAt: now, 
      updatedAt: now,
    );

    expect(entity.id, '99999999-9999-9999-9999-999999999999');
    expect(entity.assemblageId, '88888888-8888-8888-8888-888888888888');
    expect(entity.porosity, null);
    expect(entity.sizeUpper, null);
    expect(entity.sizeLower, null);
    expect(entity.comment, '');
    expect(entity.preExcavFrags, 1);
    expect(entity.postExcavFrags, 1);
    expect(entity.elements, 1);
    expect(entity.createdAt, now);
    expect(entity.updatedAt, now);
  });

  /*-----------------------------------------------------------------*/

  // Test Case 3: Test Assertions

  // 3(a): Empty ID
  test('Will throw an AssertionError if id is empty', () {
    expect(() => ArtifactFaunalEntity(
      id: '', 
      assemblageId: '88888888-8888-8888-8888-888888888888',
      porosity: 3,
      sizeUpper: 4,
      sizeLower: 1, 
      comment: '', 
      preExcavFrags: 1, 
      postExcavFrags: 1, 
      elements: 1, 
      createdAt: now, 
      updatedAt: now),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(b): Empty Assemblage ID
  test('Will throw an AssertionError if assemblageID is empty', () {
    expect(() => ArtifactFaunalEntity(
      id: '', 
      assemblageId: '99999999-9999-9999-9999-999999999999',
      porosity: 3,
      sizeUpper: 4,
      sizeLower: 1, 
      comment: '', 
      preExcavFrags: 1, 
      postExcavFrags: 1, 
      elements: 1, 
      createdAt: now, 
      updatedAt: now),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(c): porosity < 1
  test('Will throw an AssertionError if porosity < 1', () {
    expect(() => ArtifactFaunalEntity(
      id: '88888888-8888-8888-8888-888888888888', 
      assemblageId: '99999999-9999-9999-9999-999999999999',
      porosity: 0,
      sizeUpper: 4,
      sizeLower: 1, 
      comment: '', 
      preExcavFrags: 1, 
      postExcavFrags: 1, 
      elements: 1, 
      createdAt: now, 
      updatedAt: now),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(d): porosity > 5
  test('Will throw an AssertionError if porosity > 5', () {
    expect(() => ArtifactFaunalEntity(
      id: '88888888-8888-8888-8888-888888888888', 
      assemblageId: '99999999-9999-9999-9999-999999999999',
      porosity: 6,
      sizeUpper: 4,
      sizeLower: 1, 
      comment: '', 
      preExcavFrags: 1, 
      postExcavFrags: 1, 
      elements: 1, 
      createdAt: now, 
      updatedAt: now),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(e): sizeUpper < sizeLower
  test('Will throw an AssertionError if sizeUpper < sizeLower', () {
    expect(() => ArtifactFaunalEntity(
      id: '88888888-8888-8888-8888-888888888888', 
      assemblageId: '99999999-9999-9999-9999-999999999999',
      porosity: 3,
      sizeUpper: 1,
      sizeLower: 5, 
      comment: '', 
      preExcavFrags: 1, 
      postExcavFrags: 1, 
      elements: 1, 
      createdAt: now, 
      updatedAt: now),
        throwsA(isA<AssertionError>())
    );
  });

  // 3(f): preExcavFrags, postExcavFrags, elements < 1
  test('Will throw an AssertionError if preExcavFrags, postExcavFrags, elements < 1', () {
    expect(() => ArtifactFaunalEntity(
      id: '88888888-8888-8888-8888-888888888888', 
      assemblageId: '99999999-9999-9999-9999-999999999999',
      porosity: 3,
      sizeUpper: 4,
      sizeLower: 2, 
      comment: '', 
      preExcavFrags: 0, 
      postExcavFrags: 0, 
      elements: 0, 
      createdAt: now, 
      updatedAt: now),
        throwsA(isA<AssertionError>())
    );
  });

  /*-----------------------------------------------------------------*/

  /********************************************** ArtifactFaunalModel Tests ***********************************************/

  // Test Case 4: General Test Case
  test('Create model with valid inputs', () {
    final ArtifactFaunalModel model = ArtifactFaunalModel(
      id: '99999999-9999-9999-9999-999999999999', 
      assemblageId: '88888888-8888-8888-8888-888888888888',
      porosity: 3,
      sizeUpper: 3,
      sizeLower: 2,
      comment: 'Bone',
      preExcavFrags: 1,
      postExcavFrags: 1,
      elements: 1, 
      createdAt: now, 
      updatedAt: now,
    );

    expect(model.id, '99999999-9999-9999-9999-999999999999');
    expect(model.assemblageId, '88888888-8888-8888-8888-888888888888');
    expect(model.porosity, 3);
    expect(model.sizeUpper, 3);
    expect(model.sizeLower, 2);
    expect(model.comment, 'Bone');
    expect(model.preExcavFrags, 1);
    expect(model.postExcavFrags, 1);
    expect(model.elements, 1);
    expect(model.createdAt, now);
    expect(model.updatedAt, now);
  });

  /*-----------------------------------------------------------------*/

  // Test Case 5: Test toEntity() Function

  // 5(a): Return ArtifactFaunalEntity with Same Values
  test('toEntity() should return ArtifactFaunalEntity with same values it had before conversion', () {
    final ArtifactFaunalModel model = ArtifactFaunalModel(
      id: '99999999-9999-9999-9999-999999999999', 
      assemblageId: '88888888-8888-8888-8888-888888888888',
      porosity: 3,
      sizeUpper: 3,
      sizeLower: 2,
      comment: 'Bone',
      preExcavFrags: 1,
      postExcavFrags: 1,
      elements: 1, 
      createdAt: now, 
      updatedAt: now,
    );

    final ArtifactFaunalEntity entity = model.toEntity();

    expect(model.id, entity.id);
    expect(model.assemblageId, entity.assemblageId);
    expect(model.porosity, entity.porosity);
    expect(model.sizeUpper, entity.sizeUpper);
    expect(model.sizeLower, entity.sizeLower);
    expect(model.comment, entity.comment);
    expect(model.preExcavFrags, entity.preExcavFrags);
    expect(model.postExcavFrags, entity.postExcavFrags);
    expect(model.elements, entity.elements);
    expect(model.createdAt, entity.createdAt);
    expect(model.updatedAt, entity.updatedAt);
  });

  // 5(b): Ensure toEntity() Returns a ArtifactFaunalEntity
  test('Ensure toEntity() funtion returns an ArtifactFaunalEntity', () {
    final ArtifactFaunalModel model = ArtifactFaunalModel(
      id: '99999999-9999-9999-9999-999999999999', 
      assemblageId: '88888888-8888-8888-8888-888888888888',
      porosity: 3,
      sizeUpper: 3,
      sizeLower: 2,
      comment: 'Bone',
      preExcavFrags: 1,
      postExcavFrags: 1,
      elements: 1, 
      createdAt: now, 
      updatedAt: now,
    );

    expect(model.toEntity(), isA<ArtifactFaunalEntity>());
  });

  /*-----------------------------------------------------------------*/

}


