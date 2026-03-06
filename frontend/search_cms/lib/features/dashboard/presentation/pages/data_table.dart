import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../bloc/data_table_cubit.dart';
import '../bloc/data_table_state.dart';


/// Data table widget, which will be used to display search results in the dashboard home page
  // TODO: This should be it's own class that manages it's own state
  // Then we can replace the query with a Circular loading wheel while
  // long queries are loading in, show complete table on success and
  // show an error message on DB fail, empty search yield, etc.
  class DataTable extends StatelessWidget {
    const DataTable({super.key});

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: TableView.builder(
          columnCount: 4,
          rowCount: 10,
          columnBuilder: (index) => buildColumnSpan(index, context),
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
      );
    }

    TableSpan buildRowSpan(int index){
      // add row level decorations here
      return TableSpan(extent: FixedTableSpanExtent(50));
    }

    TableSpan buildColumnSpan(int index, BuildContext context){
      // add col level decorations here
      // TODO: replace 4 with dynamic column count based on search results, and adjust the extent accordingly
      return TableSpan(extent: FractionalTableSpanExtent(1 / 4),);
    }
  }