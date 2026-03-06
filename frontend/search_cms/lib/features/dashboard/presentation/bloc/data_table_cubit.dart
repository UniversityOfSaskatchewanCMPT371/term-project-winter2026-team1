import 'package:bloc/bloc.dart';
import './data_table_state.dart';

// Manager for functions of the data table
class DataTableCubit extends Cubit<DataTableState> {
  DataTableCubit() : super(const DataTableInitial());

  // TODO: replace this
  // Generate a 10 row x 4 col table
  final Set<String> sampleColumns = {"Title", "Site", "Unit", "Level"};
  final List<List<String>> sampleRows = List.generate(
    10, (rowIndex) => List.generate(
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