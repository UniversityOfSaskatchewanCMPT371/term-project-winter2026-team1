import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/features/dashboard/domain/entities/table_row_entity.dart';
import './data_table_state.dart';

// ignore_for_file: unnecessary_null_comparison

// Manager for functions of the data table
class DataTableCubit extends Cubit<DataTableState> {
  DataTableCubit() : super(const DataTableInitial());

  // Column headers for table
  final Set<String> columnHeaders = {
    'Borden',
    'Site Name',
    'Area',
    'Unit',
    'Level',
    'Up Limit',
    'Low Limit',
    'Assemblage',
    'Porosity',
    'Size Upper',
    'Size Lower',
    'Pre Excav Frags',
    'Post Excav Frags',
    'Elements',
    'Comment',
  };

  // for storing the resulting rows fetched from the database (allows search to access the rows)
  List<TableRowEntity> tableRows = [];

  // Initial function to render display table with a dump of all data
  // Should only be called by init()
  // Pre-conditions: Home page being rendered for the first time
  // Post-conditions: Table displays all available data
  // This might be very slow if the fetch takes a long time and data is big
  void initialFetch(List<TableRowEntity> entities) {
    // List of rows for the table where each row is a list of strings 
    // One string per column
    List<List<String>> allRows = [];

    tableRows = entities;
    allRows = prepareTableRowEntitiesForDisplay(entities);

    // Once finished converting all entities we can emit the state with the data
    emit(DataTableLoaded(rows:allRows, columns: columnHeaders));
  }

  // Turns a list of TableRowEntities into the format to display it
  List<List<String>> prepareTableRowEntitiesForDisplay(List<TableRowEntity> rows){
    List<List<String>> allRows = [];

    // Loop through each entity and convert everything to string
    for (TableRowEntity entity in rows) {
      // Must handle the entities that can be null first
      String porosity;
      if (entity.porosity != null) {
        porosity = entity.porosity.toString();
      } else {
        porosity = '';
      }
      String sizeUpper;
      if (entity.sizeUpper != null) {
        sizeUpper = entity.sizeUpper.toString();
      } else {
        sizeUpper = '';
      }
      String sizeLower;
      if (entity.sizeLower != null) {
        sizeLower = entity.sizeLower.toString();
      } else {
        sizeLower = '';
      }
      // Build the full row and add to allRows 
      List<String> row = [
      entity.borden,
      entity.siteName,
      entity.areaName,
      entity.unitName,
      entity.levelName,
      entity.upLimit.toString(),
      entity.lowLimit.toString(),
      entity.assemblageName,
      porosity,
      sizeUpper,
      sizeLower,
      entity.preExcavFrags.toString(),
      entity.postExcavFrags.toString(),
      entity.elements.toString(),
      entity.comment,
      ];
      allRows.add(row);
    }

    return allRows;
  }

  // Update the display of the table without making a new query
  // Called when filtered columns changes. Should be able to handle both data already being
  // displayed and automatically reload table and no data being displayed, in which case
  // we can simple store the column set
  //
  // Pre-conditions: None
  // r is the existing rows from what was currently displayed
  // newCols is a new set of columns to display
  // Post-conditions: Stored set of columns will be updated. If state == DataTableLoaded
  //    then trigger table reload
  void updateColumns(List<List<String>> r, Set<String> newCols) {
    emit(DataTableLoaded(rows: r, columns: newCols));
    // If any failure occurs (connection, no results found, etc.) emit DataTableError with message
  }


  /*
  Gets the rows from the last initialFetch, passes it to basicSearch and displays the results

  input:
    query: the substring that will be searched for in each row
  
  postCondition:
    updates the staate of DataTableCubit

  */
  void basicFetch(String query) {

    // does the basic search and turns it into the correct format to display the results
    List<List<String>> rowResults =  prepareTableRowEntitiesForDisplay(basicSearch(tableRows, query));
    emit(DataTableLoaded(rows:rowResults, columns: columnHeaders));
  }

  // query database for an advanced search
  void advancedFetch() {
    // TBD
  }
}





/*
A basic search function that filters out rows from the homepage that don't contain searchString

input:
  rows: a list of rows in the table on the homepage
  searchString: the string that will be searched for in each row

Preconditions: 
  rows != NULL, 
  searchString != NULL

Postcondition: 
  will NOT modify rows,

returns:
  A list of all rows[i] that has an attribute where .contains(searchString) is true,
  if searchString is "" then it will return the original list,

properties / formal specification:
  basicSearch(rows1, string1) == basicSearch(basicSearch(rows1, string1), string1) // calling it on itself with the same searchString will not change the output
  
  basicSearch(rows1, string1).length >= basicSearch(basicSearch(rows1, string1), string2).length // calling it on its own output with a different searchString will reduce or keep the same size

  basicSearch(rows1, "") == rows1

  basicSearch([], string1) == []

  at time1 basicSearch(rows1, string1) == at time2 basicSearch(rows1, string1) // given the same input, calling basicSearch at different times will return the same result

  basicSearch(L, searchString)
  returns List M where there exists M[k] forall L[i] where there exists L[i].j.contains(searchString) // M only consists of rows in no guaranteed order from L where rows.someAttribute.contains(searchString) == true

  0 <= list M.length <= input list L.length
*/
List<TableRowEntity> basicSearch(List<TableRowEntity> rows, String searchString,) {
  String searchQuery = searchString.trim(); 

   final Logger logger = Logger('Basic search');
   logger.info("basic search for $searchQuery");

  List<TableRowEntity> result = rows.where((row) {
    // look through TableRowEntity's attributes for searchString

    if (row == null){return false;}

    // Although some attributes cannot be null, some can so I'd rather have the safeguards up for them all
    // Site
    bool inSite = (row.borden != null && row.borden.contains(searchQuery)) 
      || (row.siteName != null && row.siteName.contains(searchQuery));

    // Area
    bool inArea = (row.areaName != null && row.areaName.contains(searchQuery));

    // Unit
    bool inUnit = (row.unitName != null && row.unitName.contains(searchQuery));

    // Level
    bool inLevel = (row.levelName != null && row.levelName.contains(searchQuery))
      || (row.upLimit != null && row.upLimit.toString().contains(searchQuery))
      || (row.lowLimit != null && row.lowLimit.toString().contains(searchQuery));

    // Assemblage
    bool inAssemblage = (row.assemblageName != null && row.assemblageName.contains(searchQuery));

    // Artifact_Faunal
    bool inArtifactFaunal = (row.porosity != null && row.porosity.toString().contains(searchQuery))
      || (row.sizeUpper != null && row.sizeUpper.toString().contains(searchQuery))
      || (row.sizeLower != null && row.sizeLower.toString().contains(searchQuery))
      || (row.comment != null && row.comment.contains(searchQuery))
      || (row.preExcavFrags != null && row.preExcavFrags.toString().contains(searchQuery))
      || (row.postExcavFrags != null && row.postExcavFrags.toString().contains(searchQuery))
      || (row.elements != null && row.elements.toString().contains(searchQuery));


    return inSite || inArea || inUnit || inLevel || inAssemblage || inArtifactFaunal; // if true, include the row
  }).toList(); // turning the iterator (from where) into a list for the proper return type

  logger.info("results of basicSearch for $searchQuery : $result");
  return result;
}

