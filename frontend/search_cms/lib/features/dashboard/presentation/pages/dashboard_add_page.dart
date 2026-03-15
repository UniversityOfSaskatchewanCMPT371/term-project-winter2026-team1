import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/utils/constants.dart';


final Logger? _logger =
      logLevel != Level.OFF ? Logger('Add data page UI') : null;


// Its not going to be used right now since we are removing the section for the save button
// We will use this function laterwards when the save widget button comes back  
 void saveButtonClicked(String title){
  //AddDataPageEntries? dataEntry = AddDataPageEntries.dataEntries[title]; //un comment this out when business logic is started
  // implement when business logic is planned or when I can talk to them

  _logger?.info("save button was clicked for $title widget");


}

/*
Will be used to store the keys for for the text fields of widgets created by
createAddDataWidget.
If needed, can be modified to store information about what type a text field
will need to be converted to later.
*/
class AddDataPageEntries{

  // so business logic can get relevent keys using the title
  static Map <String, AddDataPageEntries> dataEntries = {}; // maps title to the instance of this class that will store the relevent keys

  String title; 

  List<String> textFieldKeys = [];
  // String saveButtonKey = ""; // to allow testers to press the button (will be used later when the "Save" button will be implemented..)

  AddDataPageEntries(this.title, this.textFieldKeys){
    dataEntries[title] = this;
  }
}

/*
 * Creates the widgets for adding data to the database
 * preconditions: unique title and text field names such that
 *    - find.byKey(Key(title + "-" + textFieldNames[index])) from flutter test 
 *      will refer to only one widget
 *    - the title is unique to any other titles passed to this function
 *    - that "title-saveButton" isn't a taken key
 * postconditions: 
 *    - the widget keys 'title + "-" + textFieldNames[index]' will be taken
 *    - will add an entry to AddDataPageEntries mapping dataEntries[title] to 
 *      an instance of AddDataPageEntries
 * returns a widget for adding an entry to the data base for a table corrosponding to title
 */
Widget createAddDataWidget(String title, List<String> textFieldNames){
  List<String> newKeys = [];
  
  for (int index = 0; index < textFieldNames.length; index++){
    String keyName = "$title-${textFieldNames[index]}";

    // apparently these asserts cause problems if the page is reloaded
    // assert(find.byKey(Key(keyName)).evaluate().isEmpty, "Add data page tried to create a widget with an already existing key: $keyName");
    newKeys.add(keyName);
  }

  //String saveButtonKey = "$title-saveButton";

  // apparently these asserts cause problems if the page is reloaded
  // assert(find.byKey(Key(saveButtonKey)).evaluate().isEmpty, "Add data page tried to create a widget with an already existing key: $saveButtonKey");

  AddDataPageEntries(title, newKeys);
  double widgetWidth = 250;

  return Container(
    width: widgetWidth,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),

      child: Column(
        
        
        children: [
          // title of table
          Container( 
            width:widgetWidth,
            color: Color(0xFF1f40b0),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30
              ),
            ),
          ),


          // text fields
          ...textFieldNames.map((name) {
            /*
              map returns an iterable (kind of like a list) the ... pulls the items out.
              So it goes from [widget, widget] to widget, widget
            */
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10),

              child: TextField(
                key: Key("$title-$name"),
                maxLines: null,
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  hintText: name,
                  border: OutlineInputBorder(),
                ),
              ),
              
              );
          }),

        ],
      ),
  );
}


class DashboardAddPage extends StatelessWidget { 
  const DashboardAddPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Add Data'),
      ),
      body:  
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Wrap(
            direction: Axis.horizontal,
            children: [ 
              /*
              this is where you will add the columns and text fields for adding
              data to the database
              */
              createAddDataWidget("Site", ["name", "borden"]),
              createAddDataWidget("Area", ["name"]),
              createAddDataWidget("Unit", ["name", "site name"]),
              createAddDataWidget("Level", ["name", "unit name", "parent name", "upper limit", "lower limit"]),
              

            ]
          ),
        )
        
    );
    
  }
}



