import 'package:bloc/bloc.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';

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

    // check that all mandatory fields exist based on the existing section titles
    List<String> missingFields = _validateFieldEntries(inputs);
    if (missingFields.isNotEmpty) {
      // TODO idk what to do here yet, need to add UX to display warnings
      // Maybe add a state SaveIncomplete that will take the list and display the message
      return;
    }

    // display a little waiter
    emit(SaveLoading());

    final usecases = getIt<DashboardUsecases>();

    // iterate over the map and filter out calls into repespective types
    // possible keys inlude Site Information, Unit, Level, Assemblage, Artifact (Faunal)
    // hyphonated with -feildName (ie. Unit-Name, Unit-Site Name)
    // Determine which sections are present by splitting on '-'
    final Set<String> sections = inputs.keys.map((k) => k.split('-').first).toSet();
    List<Future<Result>> results = [];

    for (String section in sections) {
      // for each possible type, collect inputs and call corresponding API call
      switch (section) {
        case 'Site Information':
          final borden = inputs['Site Information-Borden']!;
          final name = inputs['Site Information-Name'];
          results.add(usecases.insertSiteUsecase(borden: borden, name: name));
          
          final String area = inputs['Site Information-Area']!;
          results.add(usecases.insertAreaUsecase(name: area));

        case 'Unit':
          final name = inputs['Unit-Name']!;
          final siteName = inputs['Unit-Site Name']!;
          // TODO: resolve siteName to a siteId before calling usecase
          // Why does this usecase take in an ID????
          results.add(usecases.insertUnitUsecase(siteId: siteName, name: name));

        case 'Level':
          final name = inputs['Level-Name']!;
          final unitName = inputs['Level-Unit Name']!;
          final parentName = inputs['Level-Parent Name'];
          final upperLimit = inputs['Level-Upper Limit'] ?? 0;
          final lowerLimit = inputs['Level-Lower Limit'] ?? 0;
          // TODO: resolve unitName to unitId, parentName to parentId before calling usecase
          // TODO: collect upLimit and lowLimit from form inputs
          results.add(usecases.insertLevelUsecase(
            unitId: unitName,
            name: name,
            upLimit: upperLimit,
            lowLimit: lowerLimit,
            parentId: parentName,
          ));

        case 'Assemblage':
          final name = inputs['Assemblage-Assemblage Name']!;
          final unitName = inputs['Assemblage-Unit Name']!;
          final levelName = inputs['Assemblage-Parent Name']!;
          // results.add(usecases.insertAssemblageUsecase(name: name, unitName: unitName, levelName: levelName));

        case 'Artifact (Faunal)':
          // TODO: collect artifact inputs and call insertArtifactFaunalUsecase
          final assemblageName = inputs['Artifact (Faunal)-Assemblage Name']!;
          final porosity = inputs['Artifact (Faunal)-Porosity'];
          final 
          // results.add(usecases.insertArtifactFaunalUsecase(assemblageId: ...));

        default:
          emit(SaveFailure("Unknown Section Key Detected"));
      }
    }

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
  List<String> _validateFieldEntries(Map<String, String> fields) {
    List<String> result = [];

    // Determine which sections are present by splitting on '-'
    final sections = fields.keys.map((k) => k.split('-').first).toSet();

    // Required fields per section
    const sectionRequirements = <String, List<String>>{
      // Section Title : [Required Fields]
      'Site Information': ['Name', 'Borden', 'Area'],
      'Unit': ['Name', 'Site Name'],
      'Level': ['Name', 'Unit Name', 'Parent Name'],
      'Assemblage': ['Assemblage Name', 'Unit Name', 'Level Name'],
      'Artifact (Faunal)': ['Assemblage Name'], 
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
