import 'package:bloc/bloc.dart';
import 'package:search_cms/core/utils/constants.dart';
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
    emit(HomeLoaded(
      // emit new state with modified index and the same columns
      selectedSearch: index,
      selectedColumns: current.selectedColumns,
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
    ));
  }

  // Add additional methods to handle search here
}