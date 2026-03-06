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
            DataTableInitial() => const SizedBox.shrink(), // I dont think this would ever actually happen 
            DataTableLoading() => const Center(child: CircularProgressIndicator()),
            DataTableLoaded() => TableView.builder(
              columnCount: state.columns.length,
              rowCount: state.rows.length,
              columnBuilder: (index) => buildColumnSpan(index, state.columns.length, context),
              rowBuilder: buildRowSpan,

              // TODO: placeholder - need to figure out how to render data from the backend here
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
                    child: Text('Cell ${vicinity.column} : ${vicinity.row}'),
                  ),
                );
              },
            ),
            DataTableError() => Center(child: Text(state.message))
          };
        }
      );
    }

    TableSpan buildRowSpan(int index){
      // add row level decorations here
      return TableSpan(extent: FixedTableSpanExtent(50));
    }

    TableSpan buildColumnSpan(int index, int cols, BuildContext context){
      // add col level decorations here
      // TODO: replace 4 with dynamic column count based on search results, and adjust the extent accordingly
      return TableSpan(extent: FractionalTableSpanExtent(1 / cols),);
    }
  }