import 'package:bloc/bloc.dart';
import 'package:search_cms/features/dashboard/domain/entities/table_row_entity.dart';
import './data_table_state.dart';

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

  // Initial function to render display table with a dump of all data
  // Should only be called by init()
  // Pre-conditions: Home page being rendered for the first time
  // Post-conditions: Table displays all available data
  // This might be very slow if the fetch takes a long time and data is big
  void initialFetch(List<TableRowEntity> entities) {
    // List of rows for the table where each row is a list of strings 
    // One string per column
    List<List<String>> allRows = [];
    TableRowEntity entity;

    // Loop through each entity and convert everything to string
    for (entity in entities) {
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

    // Once finished converting all entities we can emit the state with the data
    emit(DataTableLoaded(rows:allRows, columns: columnHeaders));
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