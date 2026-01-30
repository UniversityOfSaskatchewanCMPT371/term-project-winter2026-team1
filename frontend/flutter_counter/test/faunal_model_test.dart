import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_supabase_template/models/faunal_model.dart';

void main() {

  // Test 1(a) — fromMap() correctness
  test('FaunalModel.fromMap correctly parses Supabase row', () {
    final map = {
      'id': 1, 
      'site': 'DiRw-28', 
      'unit': 'N84SW1', 
      'year_of_analysis': 2017, 
      'bone': 'mammal',
      'description': 'large bone frags'
    };

    final data = FaunalModel.fromMap(map);

    expect(data.id, 1);
    expect(data.site, 'DiRw-28');
    expect(data.unit, 'N84SW1');
    expect(data.yearOfAnalysis, 2017);
    expect(data.bone, 'mammal');
    expect(data.description, 'large bone frags');
  });

  // Test 1(b) — fromMap() correctness
  test('FaunalModel.fromMap correctly parses Supabase row', () {
    final map = {
      'id': 2, 
      'site': 'DiRw-28', 
      'unit': 'N84SW1', 
      'year_of_analysis': 2017, 
      'bone': 'bird',
      'description': null
    };

    final data = FaunalModel.fromMap(map);

    expect(data.id, 2);
    expect(data.site, 'DiRw-28');
    expect(data.unit, 'N84SW1');
    expect(data.yearOfAnalysis, 2017);
    expect(data.bone, 'bird');
    expect(data.description, null);
  });

  // Test 1(c) — fromMap() correctness
  test('FaunalModel.fromMap correctly parses Supabase row', () {
    final map = {
      'id': 3, 
      'site': 'DiRw-28', 
      'unit': 'N100SW2', 
      'year_of_analysis': 2017, 
      'bone': 'bird',
      'description': 'bone'
    };

    final data = FaunalModel.fromMap(map);

    expect(data.id, 3);
    expect(data.site, 'DiRw-28');
    expect(data.unit, 'N100SW2');
    expect(data.yearOfAnalysis, 2017);
    expect(data.bone, 'bird');
    expect(data.description, 'bone');
  });
}

 // Test 1 — Valid Data Construction
  // test('Data is created with valid values', () {
  //   final data = FaunalModel(
  //     id: 1, 
  //     site: 'DiRw-28', 
  //     unit: 'N84SW1', 
  //     yearOfAnalysis: 2017, 
  //     bone: 'mammal',
  //     description: 'large bone frags'
  //   );

  //   expect(data.id, 1);
  //   expect(data.site, 'DiRw-28');
  //   expect(data.unit, 'N84SW1');
  //   expect(data.yearOfAnalysis, 2017);
  //   expect(data.bone, 'mammal');
  //   expect(data.description, 'large bone frags');
  // });


