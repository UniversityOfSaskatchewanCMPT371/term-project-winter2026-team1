import 'package:flutter/material.dart';
import 'package:search_cms/core/utils/constants.dart';




/*
Will be used to store the keys for for the text fields of widgets created by
createAddDataWidget.
If needed, can be used to store information about what type a text field
will need to be converted to.
*/
class AddDataPageEntries{

  static Map <String, AddDataPageEntries> dataEntries = {};

  AddDataPageEntries(String title, List<String> textFieldKeys){
    //TODO
  }
}

/*
 * Creates the widgets for adding data to the database
 * preconditions: unique title and text field names such that
 *    - find.byKey(ValueKey(title + "-" + textFieldNames[index])) from flutter test 
 *      will refer to only one widget
 *    - the title is unique to any other titles passed to this function
 * postconditions: 
 *    - the widget keys 'title + "-" + textFieldNames[index]' will be taken
 *    - will add an entry to AddDataPageEntries mapping dataEntriesKeys[title] to 
 *      an instance of AddDataPageEntries
 * returns a widget for adding an entry to the data base for a table corrosponding to title
 */
Widget createAddDataWidget(String title, List<String> textFieldNames){
  //TODO

  return Container(); //may change the type of widget returned
}


class DashboardAddPage extends StatelessWidget { //TODO: potentially change type
  const DashboardAddPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Add Placeholder'),
      ),
      body: const Center(
        child: Text('Add Page TODO'),
      ),
    );
  }
}
