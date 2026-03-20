import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
Widget createAddDataWidget( BuildContext context, String title, List<String> textFieldNames){
  // apparently these asserts cause problems if the page is reloaded
  // assert(find.byKey(Key(saveButtonKey)).evaluate().isEmpty, "Add data page tried to create a widget with an already existing key: $saveButtonKey");
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
                  //Adds a textFormField with validation

                  //The following function will be used laterwards to determine is the field types are not input into each section
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return "Please enter $name";
                  //   }
                  //   return null;
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
    _formKey.currentState!.reset();
    context.read<AddDataCubit>().resetFields();
    resetButtonClicked();
  }

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
            body: Column(
              children: [

                Expanded(
                  child: Form(
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
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
            decoration: const BoxDecoration(
              color: AppColors.addDataBackground,
              border: Border(
                top: BorderSide(color: AppColors.addDataCardBorder),
              )
            ),

            child: Row(
              //moves the button to the left
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () => _handleSave(context),
                  child: const Text("Save"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _handleReset(context),
                  child: const Text("Reset"),
                      ),
                    ],
                  ),
                ),
 
              ],
            ),
          );
        },
      ),
    );
  }
}