import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/dashboard/domain/entities/table_row_entity.dart';
import 'package:search_cms/features/dashboard/presentation/bloc/data_table_cubit.dart';


void main(){

  var testList = [
    TableRowEntity(borden: "diRx-2", siteName: "site1", areaName: "Western End of Slope", unitName: "N84SW1", levelName: "level 1", upLimit: 0, lowLimit: 0, assemblageName: "Level 1 Faunal Assemblage", comment: "some comment", preExcavFrags: 1, postExcavFrags: 1, elements: 1, porosity: 1),
    TableRowEntity(borden: "DiRx-7", siteName: "site2", areaName: "Eastern End of Slope", unitName: "N100SW2", levelName: " ", upLimit: 0, lowLimit: 0, assemblageName: "", comment: "", preExcavFrags: 1, postExcavFrags: 1, elements: 1, porosity: 4),
    TableRowEntity(borden: "diRx-28", siteName: "site3", areaName: "North End of Slope", unitName: "W84SW1", levelName: "level 2", upLimit: 1, lowLimit: 4, assemblageName: "Level 2 Faunal Assemblage", comment: "aaa", preExcavFrags: 13, postExcavFrags: 15, elements: 7, porosity: 2, sizeUpper: 14, sizeLower: 9),
    TableRowEntity(borden: "diRx-8", siteName: "site4", areaName: "South End of Slope", unitName: "N8SW1", levelName: "level 3", upLimit: 2, lowLimit: 3, assemblageName: "Level 3 Faunal Assemblage", comment: "bbbb", preExcavFrags: 1, postExcavFrags: 3, elements: 18, porosity: 3, sizeUpper: 5, sizeLower: 2),
    TableRowEntity(borden: "diRx-0", siteName: "site5", areaName: "W End of Slope", unitName: "S84SW1", levelName: "level 4", upLimit: 17, lowLimit: 21, assemblageName: "Level 3 Faunal Assemblage", comment: "ccc", preExcavFrags: 1, postExcavFrags: 6, elements: 7, porosity: 1),

  ];

  // Unit tests for basic search
  group("Unit tests for basic search", (){

    // basic search empty string search query
    test('search query is an empty string', (){
      List<TableRowEntity> result = basicSearch(testList, "");
      
      expect(result.length, testList.length);
    });


    // basic search case sensitive
    test('search query checking if it is case sensitive', (){
      List<TableRowEntity> result = basicSearch(testList, "DiRx-");

      expect(result.length, 1);
    });

    // basic search case where nothing should return
    test('search query that no rows meet its criteria', (){
      List<TableRowEntity> result = basicSearch(testList, "zzzzzzzzzxxxxxxxxxxccccccccc");

      expect(result.length, 0);
    });

    // basic search on an empty set of rows
    test('search on an empty list of rows', (){
      List<TableRowEntity> result = basicSearch([], "diR");

      expect(result.length, 0);
    });




    //  expect(result, testList[1]); doesn't work, cannot handle TableRowEntitys, but == can
    

    // basic search where site borden number meets the search criteria
    test('search where the site borden number meets the criteria', (){
      List<TableRowEntity> result = basicSearch(testList, "DiRx-7");

      bool hasExpectedRow = result.any((TableRowEntity row) {return row == testList[1];});
      if (! hasExpectedRow){fail("basicSearch failed to find the expected row when searching for borden number: 'DiRx-7' ");}
    });

    // basic search where site name meets the search criteria
    test('search where the site name meets the criteria', (){
      List<TableRowEntity> result = basicSearch(testList, "site4");

      bool hasExpectedRow = result.any((TableRowEntity row) {return row == testList[3];});
      if (! hasExpectedRow){fail("basicSearch failed to find the expected row when searching for site name: 'site4' ");}
    });

    // basic search where area name meets the search criteria
    test('search where the area name meets the criteria', (){
      List<TableRowEntity> result = basicSearch(testList, "Western End of Slope");

      bool hasExpectedRow = result.any((TableRowEntity row) {return row == testList[0];});
      if (! hasExpectedRow){fail("basicSearch failed to find the expected row when searching for area name: 'Western End of Slope' ");}
    });

    // basic search where unit name meets the search criteria
    test('search where the unit name meets the criteria', (){
      List<TableRowEntity> result = basicSearch(testList, "W84SW1");

      bool hasExpectedRow = result.any((TableRowEntity row) {return row == testList[2];});
      if (! hasExpectedRow){fail("basicSearch failed to find the expected row when searching for unit name: 'W84SW1' ");}
    });

    // basic search where level name meets the search criteria
    test('search where the level name meets the criteria', (){
      List<TableRowEntity> result = basicSearch(testList, "level 2");

      bool hasExpectedRow = result.any((TableRowEntity row) {return row == testList[2];});
      if (! hasExpectedRow){fail("basicSearch failed to find the expected row when searching for level name: 'level 2' ");}
    });

    // basic search where level upLimit meets the search criteria
    test('search where the level upLimit meets the criteria', (){
      List<TableRowEntity> result = basicSearch(testList, "17");

      bool hasExpectedRow = result.any((TableRowEntity row) {return row == testList[4];});
      if (! hasExpectedRow){fail("basicSearch failed to find the expected row when searching for level upLimit: '17' ");}
    });

    // basic search where level lowLimit meets the search criteria
    test('search where the level lowLimit meets the criteria', (){
      List<TableRowEntity> result = basicSearch(testList, "21");

      bool hasExpectedRow = result.any((TableRowEntity row) {return row == testList[4];});
      if (! hasExpectedRow){fail("basicSearch failed to find the expected row when searching for level lowLimit: '21' ");}
    });

    // basic search where assemblage name meets the search criteria
    test('search where the assemblage name meets the criteria', (){
      List<TableRowEntity> result = basicSearch(testList, "Level 1 Faunal Assemblage");

      bool hasExpectedRow = result.any((TableRowEntity row) {return row == testList[0];});
      if (! hasExpectedRow){fail("basicSearch failed to find the expected row when searching for assemblage name: 'Level 1 Faunal Assemblage' ");}
    });

    // basic search where artifact faunal porosity the search criteria
    test('search where the artifact faunal porosity meets the criteria', (){
      List<TableRowEntity> result = basicSearch(testList, "4");

      bool hasExpectedRow = result.any((TableRowEntity row) {return row == testList[1];});
      if (! hasExpectedRow){fail("basicSearch failed to find the expected row when searching for artifact faunal porosity: '4' ");}
    });

    // basic search where artifact faunal sizeUpper the search criteria
    test('search where the artifact faunal sizeUpper meets the criteria', (){
      List<TableRowEntity> result = basicSearch(testList, "14");

      bool hasExpectedRow = result.any((TableRowEntity row) {return row == testList[2];});
      if (! hasExpectedRow){fail("basicSearch failed to find the expected row when searching for artifact faunal sizeUpper: '14' ");}
    });

    // basic search where artifact faunal sizeLower the search criteria
    test('search where the artifact faunal sizeLower meets the criteria', (){
      List<TableRowEntity> result = basicSearch(testList, "9");

      bool hasExpectedRow = result.any((TableRowEntity row) {return row == testList[2];});
      if (! hasExpectedRow){fail("basicSearch failed to find the expected row when searching for artifact faunal sizeLower: '9' ");}
    });

    // basic search where artifact faunal comment the search criteria
    test('search where the artifact faunal comment meets the criteria', (){
      List<TableRowEntity> result = basicSearch(testList, "bbbb");

      bool hasExpectedRow = result.any((TableRowEntity row) {return row == testList[3];});
      if (! hasExpectedRow){fail("basicSearch failed to find the expected row when searching for artifact faunal comment: 'bbbb' ");}
    });

    // basic search where artifact faunal pre excevation fragments(preExcavFrags) the search criteria
    test('search where the artifact faunal pre excevation fragments(preExcavFrags) meets the criteria', (){
      List<TableRowEntity> result = basicSearch(testList, "13");

      bool hasExpectedRow = result.any((TableRowEntity row) {return row == testList[2];});
      if (! hasExpectedRow){fail("basicSearch failed to find the expected row when searching for artifact faunal pre excevation fragments(preExcavFrags): '13' ");}
    });

    // basic search where artifact faunal post excevation fragments(postExcavFrags) the search criteria
    test('search where the artifact faunal post excevation fragments(postExcavFrags) meets the criteria', (){
      List<TableRowEntity> result = basicSearch(testList, "15");

      bool hasExpectedRow = result.any((TableRowEntity row) {return row == testList[2];});
      if (! hasExpectedRow){fail("basicSearch failed to find the expected row when searching for artifact faunal post excevation fragments(postExcavFrags): '15' ");}
    });

    // basic search where artifact faunal elements the search criteria
    test('search where the artifact faunal elements meets the criteria', (){
      List<TableRowEntity> result = basicSearch(testList, "18");

      bool hasExpectedRow = result.any((TableRowEntity row) {return row == testList[3];});
      if (! hasExpectedRow){fail("basicSearch failed to find the expected row when searching for artifact faunal elements: '18' ");}
    });



  });

}