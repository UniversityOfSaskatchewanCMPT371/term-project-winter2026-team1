import 'package:equatable/equatable.dart';

sealed class DataTableState extends Equatable {
  const DataTableState();

  @override
  List<Object?> get props => [];
}

class DataTableInitial extends DataTableState {
  const DataTableInitial();
}

// UI state holder
class DataTableLoaded extends DataTableState {
  final int selectedSearch;
  final Set<String> selectedColumns;

  const DataTableLoaded({
    this.selectedSearch = 0,  // 0 for basic search, 1 for advanced search
    this.selectedColumns = const {}, // default to empty set, can be updated with selected columns for filtering
  });

  @override
  List<Object?> get props => [selectedSearch, selectedColumns];
}

class DataTableLoading extends DataTableState {
  
}