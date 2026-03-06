import 'package:bloc/bloc.dart';
import './data_table_state.dart';

// Manager for functions of the data table
class DataTableCubit extends Cubit<DataTableState> {
  DataTableCubit() : super(const DataTableInitial());

  // TODO: replace this
  // Generate a 10 row x 4 col table
  final List<String> columns = List.generate(4, (i) => 'Column $i');
  final List<List<String>> rows = List.generate(
    10, (rowIndex) => List.generate(
      4, (colIndex) => 'R$rowIndex C$colIndex',
    ),
  );
  void init() => emit(DataTableLoaded(rows: rows, columns: columns));
  // This should make a call to initial fetch, but only the first
  // that the table gets displayed


  // Initial function to render display table with a dump of all data
  // Should only be called by init()
  // Pre-conditions: Home page being rendered for the first time
  // Post-conditions: Table displays all available data
  // This might be very slow if the fetch takes a long time and data is big
  void initialFetch() {
    // emit(DataTableLoading());
    // await for data to return from call to API
    // Get rows and cols from query
    // emit(DataTableLoaded(rows, cols));
  }

  // Update the display of the table without making a new query
  // Called when filtered columns changes
  // Pre-conditions: Data table already has data being displayed
  // Post-conditions: Table will display the given columns
  void updateColumns(Set<String> cols) {
    
  }

  // Query database for basic search
  // Pre-conditions: query is non-empty
  // If result is empty, an appropriate message will be shown
  void basicFetch(String query) {
    // emit(DataTableLoading());
    // await for data to return from call to API
    // Get rows and cols from query
    // emit(DataTableLoaded(rows, cols));
  }

  // query database for an advanced search
  void advancedFetch() {
    // TBD
  }
}