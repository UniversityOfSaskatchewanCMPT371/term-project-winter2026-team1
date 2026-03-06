import 'package:bloc/bloc.dart';
import './data_table_state.dart';

// Manager for functions of the data table
class DataTableCubit extends Cubit<DataTableState> {
  DataTableCubit() : super(const DataTableInitial());

  void init() => emit(DataTableLoaded());

  // Initial function to render display table with a dump of all data
  // Pre-conditions: Home page being rendered for the first time
  // Post-conditions: Table displays all available data
  // This might be very slow if the fetch takes a long time and data is big
  void initialFetch() {

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

  }

  // query database for an advanced search
  void advancedFetch() {
    // TBD
  }
}