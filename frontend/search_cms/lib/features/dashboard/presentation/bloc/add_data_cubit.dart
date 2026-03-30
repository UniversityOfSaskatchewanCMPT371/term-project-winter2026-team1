import 'package:bloc/bloc.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/domain/usecases/dashboard_usecases.dart';
// import 'package:frontend/search_cms/lib/features/dashboard/domain/entities/insert_area_result_classes.dart';
// May not need all of these
// frontend/search_cms/lib/features/dashboard/domain/entities/insert_level_result_classes.dart
// frontend/search_cms/lib/features/dashboard/domain/entities/insert_site_area_result_classes.dart
// frontend/search_cms/lib/features/dashboard/domain/entities/insert_site_result_classes.dart
// frontend/search_cms/lib/features/dashboard/domain/entities/insert_unit_result_classes.dart
import 'add_data_state.dart';
import '../../domain/entities/area_entity.dart';
import '../../domain/entities/site_entity.dart';
import '../../domain/entities/site_area_entity.dart';
import '../../domain/entities/level_entity.dart';
import '../../domain/entities/assemblage_entity.dart';
import '../../domain/entities/artifact_faunal_entity.dart';


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

class AddDataCubit extends Cubit<AddDataState> {
  // starting state for the add data page
  AddDataCubit() : super(const AddDataInitial());

  // loads the starting data and then moves the Add Data Page to a loaded state
  void init() {}

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
    Map<String, String> updatedFieldValues = {};

    // This makes sure that if the add data page is already loaded, it keeps the old field values
    // No field values are being deleted
    if (state is AddDataLoaded) {
      AddDataLoaded current = state as AddDataLoaded;
      updatedFieldValues = Map<String, String>.from(current.fieldValues);
    }

    updatedFieldValues['$sectionTitle-$fieldName'] = value;

    //emit the new state to the add data loaded values
    emit(AddDataLoaded(fieldValues: updatedFieldValues));
  }

  // Collects all fields that are filled, organizes them and calls the corresponding backend calls
  void save() {
    // collect all inputs
    Map<String, String> inputs = {};
    if (state is AddDataLoaded) {
      AddDataLoaded current = state as AddDataLoaded;
      inputs = Map<String, String>.from(current.fieldValues);
    }

    // if no values are filled just do nothing
    if (inputs.isEmpty) {
      return;
    }

    // display a little waiter
    emit(SaveLoading());

    final usecases = getIt<DashboardUsecases>();
    // store results in a map, if any fail, throw
    //Result results = [];


    // decide which fields are filled
    // iterate over the map and filter out calls into repespective types
    // possible keys inlude Site Information, Unit, Level, Assemblage, Artifact (Faunal)
    // hyphonated with -feildName (ie. Unit-Name, Unit-Site Name)
    inputs.forEach((k, val) {
      // truncate key to everything before -
      List<String> keyList = k.split('-');
      String sectionKey = keyList.first;
      // if sectionKey == "Unit"
        if (sectionKey == "Unit") {
          // validate that existing types that are filled aren't missing anything
        }
    });


    // display success/fail
    // behavior if some succeed and some fail??

    // reset fields
    resetFields();
  }


  // Helper method for save() to verify that no mandatory fields are missing
  // from the Map of currently filled entries. This needs to be called prior to
  // any backend API calls to avoid the case where some forms get inserted into the
  // database before aborting due to do unfilled entires.
  //
  // returns: list of fields that needed to be filled but were empty
  // if return value has lengthq == 0, we can proceed
  List<String> validateFieldEntries(Map<String, String> fields) {
    List<String> result = [];

    // Determine which sections are present
    final sections = fields.keys.map((k) => k.split('-').first).toSet();

    // Required fields per section
    const sectionRequirements = <String, List<String>>{
      'Site Information': ['Name', 'Borden', 'Area'],
      'Unit': ['Name', 'Site Name'],
      'Level': ['Name', 'Unit Name', 'Parent Name'],
      'Assemblage': ['Unit Name', 'Parent Name'],
      'Artifact (Faunal)': [], // stub
    };

    for (final section in sections) {
      final required = sectionRequirements[section];
      if (required == null) continue;

      for (final field in required) {
        final key = '$section-$field';
        if ((fields[key] ?? '').trim().isEmpty) {
          result.add(field);
        }
      }
    }

    return result;
  }
}
