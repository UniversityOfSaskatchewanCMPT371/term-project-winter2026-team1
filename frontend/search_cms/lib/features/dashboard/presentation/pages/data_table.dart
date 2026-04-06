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
      return Column(
        children: [
          // Text field for results
          Align(
            alignment: Alignment.centerRight,
            child: BlocBuilder<DataTableCubit, DataTableState>(
              builder: (context, state) {
                if (state is DataTableLoaded) {
                  int rowCount = state.rows.length;
                  return Text('results: $rowCount', style: const TextStyle(color: Colors.blueGrey));
                } else {
                  int rowCount = 0;
                  return Text('results: $rowCount', style: const TextStyle(color: Colors.blueGrey));
                }
              },
            ),
          ),
          // Headers
          Row(
            children: [
              // Loops over every header name and builds widget for it
              for (final String column in DataTableCubit.columnHeaders)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      color: Colors.blueGrey,
                    ),
                    child: Text(column,
                    softWrap: false,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Now the data table will be below the headers 
          Expanded(
            child: BlocBuilder<DataTableCubit, DataTableState>(
              builder: (context, state) {
                return switch (state) {
                  // Initial state is not reachable with current set-up in home page,
                  // But i've left this here in case we move away from having pre-loaded data
                  DataTableInitial() => const Center(child: Text("Welcome to the sEARCH home page")),
                  DataTableLoading() => const Center(child: CircularProgressIndicator()),

                  /**
                   * This guard is needed because if the db has nothing in
                   * it then TableView.builder just crashes so we need to prevent that from happening
                   */
                  DataTableLoaded() => state.rows.isEmpty
                    ? const Center(child: Text("No data in database to display"))
                    : TableView.builder(
                        columnCount: state.columns.length,
                        rowCount: state.rows.length,
                        columnBuilder: (index) => buildColumnSpan(index, state.columns.length, context),
                        rowBuilder: buildRowSpan,
                        cellBuilder:(BuildContext context, TableVicinity vicinity) {
                          return TableViewCell(
                            child: Container(
                              decoration: BoxDecoration(
                                // TODO: fix the overlap
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                )
                              ),
                              child: Text(state.rows[vicinity.row][vicinity.column]),
                            ),
                          );
                        },
                      ),

                  DataTableError() => Center(child: Text(state.message))
                };
              }
            ),
          ),
        ],
      );
    }

    TableSpan buildRowSpan(int index){
      // add row level decorations here
      return TableSpan(extent: FixedTableSpanExtent(50));
    }

    TableSpan buildColumnSpan(int index, int cols, BuildContext context){
      // add col level decorations here
      return TableSpan(extent: FractionalTableSpanExtent(1 / cols),);
    }
  }