import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../bloc/data_table_cubit.dart';
import '../bloc/data_table_state.dart';


/// Data table widget, which will be used to display search results in the dashboard home page
class DataTableWidget extends StatelessWidget {
  const DataTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataTableCubit, DataTableState>(
      builder: (context, state) {
        return switch (state) {

          // Initial state
          DataTableInitial() =>
            const Center(child: Text("Welcome to the sEARCH home page")),

          // Loading indicator
          DataTableLoading() =>
            const Center(child: CircularProgressIndicator()),

          // Loaded table
          DataTableLoaded() =>
            state.rows.isEmpty
              ? const Center(child: Text("No results found"))
              : _buildTable(state),

          // Error message
          DataTableError() =>
            Center(child: Text(state.message)),
        };
      },
    );
  }


  Widget _buildTable(DataTableLoaded state) {

    final columns = state.columns.toList();

    return TableView.builder(
      columnCount: columns.length,
      rowCount: state.rows.length + 1, // +1 for header row

      columnBuilder: (index) =>
        buildColumnSpan(index, columns.length),

      rowBuilder: buildRowSpan,

      cellBuilder: (BuildContext context, TableVicinity vicinity) {

        final isHeader = vicinity.row == 0;

        final cellText = isHeader
            ? columns[vicinity.column]
            : state.rows[vicinity.row - 1][vicinity.column];

        return TableViewCell(
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isHeader ? Colors.grey.shade300 : Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: Text(
              cellText,
              style: TextStyle(
                fontWeight:
                    isHeader ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      },
    );
  }


  TableSpan buildRowSpan(int index) {
    return const TableSpan(
      extent: FixedTableSpanExtent(50),
    );
  }


  TableSpan buildColumnSpan(int index, int cols) {
    return TableSpan(
      extent: FractionalTableSpanExtent(1 / cols),
    );
  }
}