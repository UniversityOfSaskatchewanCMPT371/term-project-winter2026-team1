import 'package:bloc/bloc.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'add_data_state.dart';

// Add Data cubit that its used for the Add Data page
// Keeps track of what the user types into the text fields and manages the state changes for the page itself
//
// preconditions:
//- The cubit should be created before the page tries to use it
//- The Dashboard will use the "use cases" from the getIt
//
// postconditions:
//- THe cubit can emit the state changes from the page
//- The page will eventually move the add data page to its initial, loading, loaded states.

//Add Data cubit that its used for the Add Data page
//Keeps track of what the user types into the text fields and manages the state changes for the page itself
//
//preconditions:
//- The cubit should be created before the page tries to use it
//- The Dashboard will use the "use cases" from the getIt
//
//postconditions:
//- THe cubit can emit the state changes from the page
//- The page will eventually move the add data page to its initial, loading, loaded states.
class AddDataCubit extends Cubit<AddDataState> {

    DashboardUsecases dashboardUsecases = getIt<DashboardUsecases>();
  //starting state for the add data page
  AddDataCubit() : super(const AddDataInitial());

// loads the starting data and then moves the Add Data Page to a loaded state
    void init() async {
    await dashboardUsecases.getAllSitesUseCase.call();
    emit(const AddDataLoaded());
    }

// Resets all the fields values for the Add Data Page
//
// preconditions:
// - The cubit initial has already been created
//
// postconditions:
// - All the saved fields that are inputed are cleared
// - The page goes into an empty state when the resetfields is through the loaded state
    void resetFields() {
      emit(const AddDataLoaded());
  }


// Adds a text field value function and runs the user types in a text field
// 3 parts: sectionTitle, fieldName, value
// It updates the stored text for one specific field
//   
// preconditions:
// - The Add Data Page should be already in a valid stage
// sectionTitle and fieldName refer to the real field thats its being used on the page
//
// postconditions:
// - The value for the fieldName is updated
// - the new value will be stored and will use the updated matching section-field key
// - the updated state will keep the latest new value
  void updateFieldValue(String sectionTitle, String fieldName, String value) {

    // places the store field names and their typed values within the different sections
    Map<String, String> updatedFieldValues = {};

    // This makes sure that if the add data page is already loaded, it keeps the old field values
    // No field values are being deleted
    if (state is AddDataLoaded) {
      AddDataLoaded current = state as AddDataLoaded;
      updatedFieldValues = Map<String,String>.from(current.fieldValues);

    }
    updatedFieldValues['$sectionTitle-$fieldName'] = value;

    //emit the new state to the add data loaded values
    emit(AddDataLoaded(
      fieldValues: updatedFieldValues,
    ));
  }

}
