import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/utils/constants.dart';
import '../bloc/add_data_cubit.dart';
import '../bloc/add_data_state.dart';
import 'package:sizer/sizer.dart';


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
  double widgetWidth = 360;

  return Container(
    width: widgetWidth,
    //Changed the padding size for edge
    padding: EdgeInsets.all(2.w),
    //Added a decoration box that seperates each section
    decoration: BoxDecoration(
      color: AppColors.addDataCard,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.addDataCardBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // section title
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.mainText,
          ),
        ),

        //Aligns with each Box Section and signifies it to its own unique part
        const SizedBox(height: 12),
        const Divider(height: 1, color: AppColors.addDataCardBorder),
        const SizedBox(height: 16),

        // text fields
        ...textFieldNames.map((name) {
            /*
              map returns an iterable (kind of like a list) the ... pulls the items out.
              So it goes from [widget, widget] to widget, widget
            */
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mainText,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  key: Key("$title-$name"),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                  ),
                  onChanged: (value) {
                    context.read<AddDataCubit>().updateFieldValue(title, name, value);
                    _logger?.info("$title-$name");
                  },

                  //The validator receives the text that user has entered
                  //Adds a textFormField with validation logic
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter $name";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter $name",
                    filled: true,
                    fillColor: AppColors.addDataFieldFill,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.addDataFieldBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.addDataFieldBorder,
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
          );
        }),
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddDataCubit()..init(),
      child: BlocBuilder<AddDataCubit, AddDataState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.addDataBackground,
            appBar: AppBar(
              backgroundColor: AppColors.addDataBackground,
              elevation: 0,
              title: const Text('Add Data'),
            ),
          
          //Build a form widget using the _formKey created above
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              //Added a outer padding that sits close to the edges
              padding: EdgeInsets.all(2.w),
              child: Wrap(
                direction: Axis.horizontal,
                //Added the right amount of spacing between each section
                spacing: 1.5.w,
                runSpacing: 1.5.h,
                children: [
                  /*
                  this is where you will add the columns and text fields for adding
                  data to the database
                  */
                  createAddDataWidget(context, "Site Information", ["Name", "Borden", "Area"]),
                  createAddDataWidget(context, "Unit", ["Name", "Site Name"]),
                  createAddDataWidget(context, "Level", ["Name", "Unit Name", "Parent Name", "Upper Limit", "Lower Limit"]),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
}
