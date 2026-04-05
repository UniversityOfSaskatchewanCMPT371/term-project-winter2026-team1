import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/domain/entities/get_all_table_rows_result_classes.dart'
    as table_rows_result;
import 'package:search_cms/features/dashboard/domain/usecases/dashboard_usecases.dart';
import './home_state.dart';


class HomeCubit extends Cubit<HomeState> {

  DashboardUsecases dashboardUsecases = getIt<DashboardUsecases>();
  final Logger _logger = Logger('Home cubit');

  HomeCubit() : super(const HomeInitial());

  void init() async {
    final Result result = await dashboardUsecases.getAllTableRowsUseCase.call();

    // If Result is of type Success at runtime we can emit the state with the actual list  
    if (result is table_rows_result.Success) {
      emit(HomeLoaded(tableRowEntities: result.listOfTableRowEntity));
    } else if (result is table_rows_result.Failure) {
      // The call failed
      _logger.warning('Failure loading table: ${result.errorMessage}');
      emit(const HomeLoaded());
    }
  }

  // Update the selected search type (basic or advanced)
  void updateSearchToggle(int index) {
    // cast state to HomeLoaded to preserve a copy of columns
    // since this method is only called from with the toggle,
    // state will always be Loaded so the case is safe
    final current = state as HomeLoaded;
    emit(HomeLoaded(
      // emit new state with modified index and the same columns
      selectedSearch: index,
      selectedColumns: current.selectedColumns,
      // Wont get deleted when switching state
      tableRowEntities: current.tableRowEntities,
    ));
  }

  // Update the selected columns for filtering
  // Only alteres the display of the pop-up
  // A call to the DataTable's cubit is also required
  void updateSelectedColumns(Set<String> columns) {
    final current = state as HomeLoaded;
    emit(HomeLoaded(
      selectedSearch: current.selectedSearch,
      selectedColumns: columns,
      // Wont get deleted when switching state
      tableRowEntities: current.tableRowEntities,
    ));
  }

  // Add additional methods to handle search here
}