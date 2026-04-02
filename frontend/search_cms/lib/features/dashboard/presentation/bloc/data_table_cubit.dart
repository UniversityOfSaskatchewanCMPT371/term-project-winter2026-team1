import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/features/dashboard/domain/entities/table_row_entity.dart';
import './data_table_state.dart';

// Manager for functions of the data table
class DataTableCubit extends Cubit<DataTableState> {
  DataTableCubit() : super(const DataTableInitial());

  // TODO: replace this
  // Generate a 10 row x 4 col table
  final Set<String> sampleColumns = {"Title", "Site", "Unit", "Level"};
  final List<List<String>> sampleRows = List.generate(
    15, (rowIndex) => List.generate(
      4, (colIndex) => 'R$rowIndex C$colIndex',
    ),
  );
  void init() => emit(DataTableLoaded(rows: sampleRows, columns: sampleColumns));
  // This should make a call to initial fetch, but only the first
  // that the table gets displayed


  // Initial function to render display table with a dump of all data
  // Should only be called by init()
  // Pre-conditions: Home page being rendered for the first time
  // Post-conditions: Table displays all available data
  // This might be very slow if the fetch takes a long time and data is big
  void initialFetch() {
    // placeholder
    emit(DataTableLoaded(rows: sampleRows, columns: sampleColumns));
    // emit(DataTableLoading());
    // await for data to return from call to API
    // Get rows and cols from query
    // Should be as simple as formatting the result into the set of Columns
    // and a list of list of rows. then just cast all the data to a string if not already
    // emit(DataTableLoaded(rows, cols));
    // If any failure occurs (connection, no results found, etc.) emit DataTableError with message
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

  // Query database for basic search
  // Pre-conditions: query is non-empty
  // If result is empty, an appropriate message will be shown
  void basicFetch(String query) {
    // emit(DataTableLoading());
    // await for data to return from call to API
    // Get rows and cols from query
    // Should be as simple as formatting the result into the set of Columns
    // and a list of list of rows. then just cast all the data to a string if not already
    // emit(DataTableLoaded(rows, cols));
    // If any failure occurs (connection, no results found, etc.) emit DataTableError with message
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

   final Logger _logger = Logger('Basic search');
   _logger.info("basic search for $searchQuery");

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

  _logger.info("results of basicSearch for $searchQuery : $result");
  return result;
}

