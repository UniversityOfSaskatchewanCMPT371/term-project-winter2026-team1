import 'package:equatable/equatable.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

// UI state holder
class DashboardLoaded extends DashboardState {
  final int selectedSearch;
  final Set<String> selectedColumns;

  const DashboardLoaded({
    this.selectedSearch = 0,  // 0 for basic search, 1 for advanced search
    this.selectedColumns = const {}, // default to empty set, can be updated with selected columns for filtering
  });

  @override
  List<Object?> get props => [selectedSearch, selectedColumns];
}

// TODO: add more states for loading, success, failure of search results
// class DashboardSearchLoading extends DashboardState { ... }
// class DashboardSearchSuccess extends DashboardState { ... }
// class DashboardSearchFailure extends DashboardState { ... }