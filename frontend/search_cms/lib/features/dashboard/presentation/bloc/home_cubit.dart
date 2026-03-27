import 'package:bloc/bloc.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/domain/entities/table_row_entity.dart';
import 'package:search_cms/features/dashboard/domain/usecases/dashboard_usecases.dart';
import './home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  DashboardUsecases dashboardUsecases = getIt<DashboardUsecases>();

  HomeCubit() : super(const HomeInitial());

  void init() async {
    await dashboardUsecases.getAllSitesUseCase.call();
    emit(const HomeLoaded());
  }

  // Update the selected search type (basic or advanced)
  void updateSearchToggle(int index) {
    // cast state to HomeLoaded to preserve a copy of columns
    // since this method is only called from with the toggle,
    // state will always be Loaded so the case is safe
    final current = state as HomeLoaded;
    emit(
      HomeLoaded(
        // emit new state with modified index and the same columns
        selectedSearch: index,
        selectedColumns: current.selectedColumns,
      ),
    );
  }

  // Update the selected columns for filtering
  // Only alteres the display of the pop-up
  // A call to the DataTable's cubit is also required
  void updateSelectedColumns(Set<String> columns) {
    final current = state as HomeLoaded;
    emit(
      HomeLoaded(
        selectedSearch: current.selectedSearch,
        selectedColumns: columns,
      ),
    );
  }

  // Add additional methods to handle search here
}


/*
A basic search function that filters out rows from the homepage that don't contain searchString

input:
  rows: a list of rows in the table on the homepage
  searchString: the string that will be searched for in each row

Preconditions: 
  rows is not NULL and has no NULL rows, searchString is not NULL

Postcondition: 
  will NOT modify rows, (TODO: double check if the returned rows are clones or the same reference, modifying a row itself will be modified in both)

returns:
  a list of entries from rows that contain a value that .contains(searchString)

properties:
  basicSearch(rows1, string1) == basicSearch(basicSearch(rows1, string1), string1) // calling it on itself with the same searchString will not change the output
  
  basicSearch(rows1, string1).length() >= basicSearch(basicSearch(rows1, string1), string2).length() // calling it on its own output with a different searchString will reduce or keep the same size

  at time1 basicSearch(rows1, string1) == at time2 basicSearch(rows1, string1) // given the same input, calling basicSearch at different times will return the same result

  basicSearch(L, searchString)
  returns List M where there exists M[k] forall L[i] where there exists L[i][j].contains(searchString) // M only consists of rows in no guaranteed order from L where .contains(searchString) == true

  0 <= list M.length() <= input list L.length()
*/
List<TableRowEntity> basicSearch(List<TableRowEntity> rows, String searchString,) {
  return rows.where((row) {
    // look through entity's attributes for searchString

    /* check list
      - check how .contains works when searchString is empty
      - check for NULL for rows[index].attribute
    */
    return true; // just a placeholder
  }).toList();
}
