import 'package:equatable/equatable.dart';

sealed class DataTableState extends Equatable {
  const DataTableState();

  @override
  List<Object?> get props => [];
}

class DataTableInitial extends DataTableState {
  // called on first mount?
  const DataTableInitial();
}

class DataTableLoading extends DataTableState {
  // intermidiate state while queries are being run
  const DataTableLoading();
}

// Loaded state
// Contains info for rendering the table
class DataTableLoaded extends DataTableState {
  final List<List<String>> rows; // placeholder, inner list should be data type
  final List<String> columns;   // headers

  const DataTableLoaded({
    required this.rows,
    required this.columns,
  });

  @override
  List<Object?> get props => [rows, columns];
}

class DataTableError extends DataTableState {
  final String message;

  const DataTableError(this.message);

  @override
  List<Object?> get props => [message];
}