import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:search_cms/core/utils/constants.dart';


import 'package:flutter_test/flutter_test.dart';

void saveButtonClicked(String title){
  AddDataPageEntries? dataEntry = AddDataPageEntries.dataEntries[title];
  //implement when business logic is planned or when I can talk to them

}


/*
Will be used to store the keys for for the text fields of widgets created by
createAddDataWidget.
If needed, can be modified to store information about what type a text field
will need to be converted to later.
*/
class AddDataPageEntries{

  // so business logic can get relevent keys using the title
  static Map <String, AddDataPageEntries> dataEntries = {}; //maps title to the instance of this class that will store the relevent keys

  String title; 

  List<String> textFieldKeys = [];
  String saveButtonKey = ""; //to allow testers to press the button

  AddDataPageEntries(this.title, List<String> this.textFieldKeys, this.saveButtonKey){
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
    String keyName = title + "-" + textFieldNames[index];

    //apparently these asserts cause problems if the page is reloaded
    // assert(find.byKey(Key(keyName)).evaluate().isEmpty, "Add data page tried to create a widget with an already existing key: $keyName");
    newKeys.add(keyName);
  }

  String saveButtonKey = "$title-saveButton";

  //apparently these asserts cause problems if the page is reloaded
  // assert(find.byKey(Key(saveButtonKey)).evaluate().isEmpty, "Add data page tried to create a widget with an already existing key: $saveButtonKey");

  AddDataPageEntries(title, newKeys, saveButtonKey);
  double widgetWidth = 250;

  return Container(
    width: widgetWidth,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),

      child: Column(
        
        
        children: [
          //title of table
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


          //text fields
          ...textFieldNames.map((name) {
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


          //save button
          ElevatedButton(
            key: Key(saveButtonKey),
            onPressed: (){saveButtonClicked(title);}, //Function ran when the button is pressed

            style: ElevatedButton.styleFrom(
              minimumSize: const Size(90, 40),
              backgroundColor: const Color(0xFF1f40b0),
              foregroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              
            ),

            child: Text(
              "Save",
              style: TextStyle(
                fontSize: 25,
              )
            ),
          ),

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
      body:  Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Wrap(
            direction: Axis.horizontal,
            children: [ 
              /*this is where you will add the columns and text fields for adding
              data to the database
              */
              createAddDataWidget("Site", ["name", "borden"]),
              createAddDataWidget("Area", ["name"]),
              createAddDataWidget("Unit", ["name", "site name"]),
              createAddDataWidget("Level", ["name", "unit name", "parent name", "upper limit", "lower limit"]),
              

            ]
          ),
        )
        
      ),
    );
  }
}



