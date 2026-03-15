import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:sizer/sizer.dart';
import '../bloc/add_data_cubit.dart';
import '../bloc/add_data_state.dart';


final Logger? _logger =
      logLevel != Level.OFF ? Logger('Add data page UI') : null;



// Its not going to be used right now since we are removing the section for the save button
// We will use this function laterwards when the save widget button comes back  
 void saveButtonClicked(){
  //AddDataPageEntries? dataEntry = AddDataPageEntries.dataEntries[title]; //un comment this out when business logic is started
  // implement when business logic is planned or when I can talk to them

  _logger?.info("save button was clicked on the add data page");
 } 

//We will use this when the function runs the reset button(when its clicked), logs a message saying that reset button was pressed
void resetButtonClicked() {
  _logger?.info("reset button was clicked on the add data page");
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
Widget createAddDataWidget( BuildContext context, String title, Map<String, String> textFieldNames, {bool twoColumnFields = false}){
  // apparently these asserts cause problems if the page is reloaded
  // assert(find.byKey(Key(saveButtonKey)).evaluate().isEmpty, "Add data page tried to create a widget with an already existing key: $saveButtonKey");
      double widgetWidth = 360;
      if (twoColumnFields) {
        widgetWidth = 625;
      }

      double fieldWidth = widgetWidth;
      if (twoColumnFields) {
        fieldWidth = 270;
      }

  return Container(
    width: widgetWidth,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFD9DEE8)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // section title
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),

        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFD9DEE8)),
        const SizedBox(height: 16),

        // text fields
        ...textFieldNames.map((name) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mainText,
                  ),
                ),

                const SizedBox(height: 8),
                TextFormField(
                  key: Key("$title-$name"),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14,
                    ),


                  onChanged: (value) {
                    context.read<AddDataCubit>().updateFieldValue(title, name, value);
                    _logger?.info("$title-$name");

                  },

                  //The validator receives the text that user has entered
                  //Adds a textFormField with validation

                  //The following function will be used laterwards to determine is the field types are not input into each section
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return "Please enter $name";
                  //   }
                  //   return null;

                  decoration: InputDecoration(
                    hintText: entryValue,
                    filled: true,
                    fillColor: AppColors.addDataFieldFill,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFFD0D7E2),
                      ),
                    ),


                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFFD0D7E2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.addDataFieldBorder,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),               
              ],
            ),
            ),
          );
        }),
      ],
    ),
      ],
    ),

    );
}

// Define a custom Form widget
class DashboardAddPage extends StatefulWidget {
  const DashboardAddPage({super.key});

  @override
  State<DashboardAddPage> createState() => DashboardAddPageState();

}

// Define a corresponding State class
// This class holds the data related to the form
class DashboardAddPageState extends State<DashboardAddPage> {

  // Creates the global key that identifies the Form widget
  // by allowing also the validation of the form in the same form
  final _formKey = GlobalKey<FormState>();

//This will run all the validators -- it only saves if every field has been passed


/// preconditions: 
///  - The form key is connected to the form and it makes sure it exists
///  - the Save Button action was triggered
///  - The form key can check and validated through the form fields
/// 
/// postconditions:
///  - If the form is valid, then the save function is called
///  - if the form is not valid, than the saving does not happen
  void _handleSave(BuildContext context) {

    // if (_formKey.currentState != null && _formKey.currentState!.validate()) {
    _logger?.info("Save Button Clicked");
      saveButtonClicked();
  }

  /// PreConditions:
  /// - The form exists and is connected through the _formkey
  /// - The addDataCubit must be avaialbe
  /// - the reset action was triggered by the user
  /// 
  /// PostConditions:
  /// - The form fields are reset
  /// - THe cubit field values are reset
  /// - THe reset function is also reset
  
  void _handleReset(BuildContext context) {
    _logger?.info("Reset Button Clicked");
    _formKey.currentState?.reset();
    context.read<AddDataCubit>().resetFields();
    resetButtonClicked();
  }

  // Builds the Add Data page layout
  // 
  //preconditions:
  // - the fieldnames context must be valid
  // - the _formkey should be already created
  //
  //postconditions:
  // - THe Add Data page layout is being returned
  // - The AddDataCubit is provided within the widget tree
  // - THe page is connected to the AddDatastate throughout changes within the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 0,
        title: const Text('Add Data'),
      ),
      body:  
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          //Added a outer padding that sits close to the edges
          padding: const EdgeInsets.all(20),
          child: Wrap(
            direction: Axis.horizontal,
            //Added the right amount of spacing between each section
            spacing: 18,
            runSpacing: 18,
            children: [ 
              /*
              this is where you will add the columns and text fields for adding
              data to the database
              */
              createAddDataWidget("Site Information", ["Name", "Borden", "Area"]),
              createAddDataWidget("Unit", ["Name", "Site Name"]),
              createAddDataWidget("Level", ["Name", "Unit Name", "Parent Name", "Upper Limit", "Lower Limit"]),
              

            ]
          ),
        )
        
    );
    
  }
}



