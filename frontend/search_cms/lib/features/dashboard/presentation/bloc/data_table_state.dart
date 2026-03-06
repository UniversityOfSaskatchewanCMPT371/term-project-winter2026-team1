import 'package:equatable/equatable.dart';

sealed class DataTableState extends Equatable {
  const DataTableState();

  @override
  List<Object?> get props => [];
}

// Not reachable with current set-up but exists in case we 
// decide to move away from having data dump by default on load
class DataTableInitial extends DataTableState {
  const DataTableInitial();
}

// Intermidiate state that shows a loading icon on home page
// Should be emitted before making a change to the table
class DataTableLoading extends DataTableState {
  // intermidiate state while queries are being run
  const DataTableLoading();
}

// Loaded state
// Contains info for rendering the table
// Emitted after queries are successful
class DataTableLoaded extends DataTableState {
  final List<List<String>> rows; // placeholder, inner list should be data type
  final Set<String> columns;   // headers

  const DataTableLoaded({
    required this.rows,
    required this.columns,
  });

  @override
  List<Object?> get props => [rows, columns];
}

// Display any error message
class DataTableError extends DataTableState {
  final String message;

  const DataTableError(this.message);

  @override
  List<Object?> get props => [message];
}