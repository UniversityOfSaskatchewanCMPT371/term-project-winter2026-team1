import 'package:bloc/bloc.dart';
import 'add_data_state.dart';


//Add Data page state that uses a Manager function
//Keeps track of what the user types into the text fields
class AddDataCubit extends Cubit<AddDataState> {
  //starting state
  AddDataCubit() : super(const AddDataInitial());

// Moves the Add Data Page to a loaded state
  void init() => emit(const AddDataLoaded());

// Adds a text field value function and runs the user types in a text field
// 3 parts: sectionTitle, fieldName, value
// It updates the stored text for one specific field
  void updateFieldValue(String sectionTitle, String fieldName, String value) {

    // places the store field names and their typed values within the different sections
    Map<String, String> updateFieldValues = {};



  }