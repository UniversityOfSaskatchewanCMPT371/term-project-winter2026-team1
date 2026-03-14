import 'package:bloc/bloc.dart';

import '../../data/data_sources/abstract_dashboard_api.dart';
import './data_table_state.dart';

// Manager for functions of the data table
class DataTableCubit extends Cubit<DataTableState> {
  final AbstractDashboardApi dashboardApi;

  DataTableCubit({
    required this.dashboardApi,
  }) : super(const DataTableInitial());

  final Set<String> defaultColumns = {
    'Title',
    'Site',
    'Unit',
    'Level',
  };

  // This should make a call to initial fetch, but only the first
  // that the table gets displayed
  Future<void> init() async => initialFetch();

  // Initial function to render display table with a dump of all data
  // Should only be called by init()
  // Pre-conditions: Home page being rendered for the first time
  // Post-conditions: Table displays all available data
  // This might be very slow if the fetch takes a long time and data is big
  Future<void> initialFetch() async {
    emit(const DataTableLoading());

    try {
      final List<List<String>> rows = await dashboardApi.basicSearch('');

      emit(DataTableLoaded(
        rows: rows,
        columns: defaultColumns,
      ));
    } catch (e) {
      emit(DataTableError('Failed to load dashboard data: $e'));
    }
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
  Future<void> basicFetch(String query) async {
    final String normalizedQuery = query.trim();

    emit(const DataTableLoading());

    try {
      final List<List<String>> rows = await dashboardApi.basicSearch(normalizedQuery);

      emit(DataTableLoaded(
        rows: rows,
        columns: defaultColumns,
      ));
    } catch (e) {
      emit(DataTableError('Basic search failed: $e'));
    }
  }

  // query database for an advanced search
  void advancedFetch() {
    // TBD
  }
}