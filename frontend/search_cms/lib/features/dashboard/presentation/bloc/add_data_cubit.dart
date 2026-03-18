import 'package:bloc/bloc.dart';
import 'add_data_state.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/domain/usecases/dashboard_usecases.dart';


//Add Data page state that uses a Manager function
//Keeps track of what the user types into the text fields
class AddDataCubit extends Cubit<AddDataState> {

    DashboardUsecases dashboardUsecases = getIt<DashboardUsecases>();
  //starting state
  AddDataCubit() : super(const AddDataInitial());

// Moves the Add Data Page to a loaded state
    void init() async {
    await dashboardUsecases.getAllSitesUseCase.call();
    emit(const AddDataLoaded());
    }

// Adds a text field value function and runs the user types in a text field
// 3 parts: sectionTitle, fieldName, value
// It updates the stored text for one specific field
  void updateFieldValue(String sectionTitle, String fieldName, String value) {

    // places the store field names and their typed values within the different sections
    Map<String, String> updatedFieldValues = {};

    // This makes sure that if the add data page is already loaded, it keeps the old field values
    //No field values are being deleted
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