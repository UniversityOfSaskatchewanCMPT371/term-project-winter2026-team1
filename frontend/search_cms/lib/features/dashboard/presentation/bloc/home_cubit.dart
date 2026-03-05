import 'package:bloc/bloc.dart';
import './home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial());

  void init() => emit(const HomeLoaded());

  // Update the selected search type (basic or advanced)
  void updateSearchToggle(int index) {
    final current = state as HomeLoaded;
    emit(HomeLoaded(
      selectedSearch: index,
      selectedColumns: current.selectedColumns,
    ));
  }

  // Update the selected columns for filtering
  void updateSelectedColumns(Set<String> columns) {
    final current = state as HomeLoaded;
    emit(HomeLoaded(
      selectedSearch: current.selectedSearch,
      selectedColumns: columns,
    ));
  }

  // Add additional methods to handle search here
}