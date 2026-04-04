import 'package:equatable/equatable.dart';
import 'package:search_cms/features/dashboard/domain/entities/table_row_entity.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

// UI state holder
class HomeLoaded extends HomeState {
  // Decides which toggle is displayed
  final int selectedSearch;
  // Set of selected columns for display purposes on pop-up
  final Set<String> selectedColumns;
  // Full list of table row entities
  final List<TableRowEntity> tableRowEntities;

  const HomeLoaded({
    this.selectedSearch = 0,  // 0 for basic search, 1 for advanced search
    this.selectedColumns = const {}, // Default to empty set, can be updated with selected columns for filtering
    this.tableRowEntities = const [], // Default to empty list
  });

  @override
  List<Object?> get props => [selectedSearch, selectedColumns, tableRowEntities];
}
