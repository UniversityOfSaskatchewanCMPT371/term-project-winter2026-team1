import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/domain/usecases/dashboard_usecases.dart';

import '../../domain/entities/insert_site_result_classes.dart'; // using to return results, could be any result classes files
import 'add_data_state.dart';

final Logger? _logger = logLevel != Level.OFF
    ? Logger('Add data page UI')
    : null;

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

  // Collects all fields that are filled, checks them and calls the corresponding backend calls
  // Handles case where all entries are empty
  // First checks for any missing required fields and aborts if needed
  // Pre-conditions:
  // - Add data page in valid state
  //
  // Post-conditions:
  // - Filled forms with all neccessary fields are saved to database
  // - Any errors are returned and saved to state
  Future<void> save() async {
    _logger?.info("Save button pressed");

    // collect all inputs
    Map<String, String> inputs = {};
    if (state is AddDataLoaded) {
      AddDataLoaded current = state as AddDataLoaded;
      inputs = Map<String, String>.from(current.fieldValues);
    }

    // if no values are filled just do nothing
    if (inputs.isEmpty) {
      _logger?.info("Save - no values found");
      return;
    }

    // check that all mandatory fields exist based on the existing section titles
    // If any required feilds are missing function aborts, no backend calls made
    List<String> missingFields = _validateFieldEntries(inputs);
    if (missingFields.isNotEmpty) {
      _logger?.warning("Save - Missing fields detected");
      // trigger error popup
      emit(SaveIncomplete(missingFields));
      // transition to Loaded so user can continue with inputs without reseting
      emit(AddDataLoaded(fieldValues: inputs));
      return;
    }

    // display a little waiter
    emit(SaveLoading());

    final usecases = getIt<DashboardUsecases>();

    // iterate over the map and filter out calls into repespective types
    // possible keys inlude Site Information, Unit, Level, Assemblage, Artifact (Faunal)
    // hyphonated with -feildName (ie. Unit-Name, Unit-Site Name)
    // This determines which sections are present by splitting on '-', taking the first
    // and then filter sections to only those where the user actually filled something in
    final Set<String> sections = inputs.keys
        .map((k) => k.split('-').first)
        .toSet()
        .where((section) => inputs.entries
            .where((e) => e.key.startsWith('$section-'))
            .any((e) => e.value.trim().isNotEmpty))
        .toSet();
    
    List<Result> results = [];

    // run each insert in sequential order to ensure correct dependency heirarchy
    if (sections.contains('Site Information')) {
      // all required fields at this point must exist
      final String borden = inputs['Site Information-Borden']!;
      final String? name = inputs['Site Information-Name'];

      _logger?.info("Save - Inserting Site");
      results.add(await usecases.insertSiteUsecase(borden: borden, name: name));
      
      final String area = inputs['Site Information-Area']!;
      
      _logger?.info("Save - Inserting Area");
      results.add(await usecases.insertAreaUsecase(name: area));
    }


    if (sections.contains('Unit')) {
      final String name = inputs['Unit-Name']!;
      final String siteName = inputs['Unit-Site Name']!;

      _logger?.info("Save - Inserting Unit");
      results.add(await usecases.insertUnitUsecase(siteName: siteName, name: name));
    }


    if (sections.contains('Level')) {
      final String name = inputs['Level-Name']!;
      final String unitName = inputs['Level-Unit Name']!;
      final String? parentName = inputs['Level-Parent Name'];
      // this syntax gets the result as an int if exists, null otherwise
      final int? upperLimit = int.tryParse(inputs['Level-Upper Limit'] ?? '');
      final int? lowerLimit = int.tryParse(inputs['Level-Lower Limit'] ?? '');
    
      _logger?.info("Save - Inserting Level");
      results.add(await usecases.insertLevelUsecase(
        unitName: unitName,
        name: name,
        upLimit: upperLimit ?? 0,   // use default behaviour of 0 if null
        lowLimit: lowerLimit ?? 0,
        parentName: parentName,
      ));
    }


    if (sections.contains('Assemblage')) {
      final String name = inputs['Assemblage-Assemblage Name']!;
      final String unitName = inputs['Assemblage-Unit Name']!;
      final String levelName = inputs['Assemblage-Level Name']!;

      _logger?.info("Save - Inserting Assemblage");
      results.add(await usecases.insertAssemblageUsecase(name: name, unitName: unitName, levelName: levelName));
    }


    if (sections.contains('Artifact (Faunal)')) {
      final String assemblageName = inputs['Artifact (Faunal)-Assemblage Name']!;
      final int? porosity = int.tryParse(inputs['Artifact (Faunal)-Porosity'] ?? '');
      final double? sizeUpper = double.tryParse(inputs['Artifact (Faunal)-Size Upper'] ?? '');
      final double? sizeLower = double.tryParse(inputs['Artifact (Faunal)-Size Lower'] ?? '');
      final int? preExcavFrags = int.tryParse(inputs['Artifact (Faunal)-Pre Excavation Fragments'] ?? '');
      final int? postExcavFrags = int.tryParse(inputs['Artifact (Faunal)-Post Excavation Fragments'] ?? '');
      final int? elements = int.tryParse(inputs['Artifact (Faunal)-Elements'] ?? '');
      final String? comment = inputs['Artifact (Faunal)-Comment'];
      
      _logger?.info("Save - Inserting Faunal Artifact");
      results.add(await usecases.insertArtifactUsecase(assemblageName: assemblageName,
          porosity: porosity, sizeUpper: sizeUpper, sizeLower: sizeLower, comment: comment,
          preExcavFrags: preExcavFrags, postExcavFrags: postExcavFrags, elements: elements));
    }

    // check results for any Failures
    List<String> errors = results
        .whereType<Failure>()
        // collect error messages
        .map((f) => f.errorMessage)
        // store in list errors
        .toList();

    // if any Failures occured, return list of errors as SaveFailure state
    if (errors.isNotEmpty) {
      _logger?.warning("Save - Errors Detected: $errors");
      emit(SaveFailure(errors));
      // preserve inputs in case user wants to retry
      emit(AddDataLoaded(fieldValues: inputs));
    } else {
      // else emit SaveSuccess
      _logger?.info("Save - all inserts successful");
      emit(SaveSuccess());
      // reset fields, emits AddDataLoaded
      resetFields();
    }
  }


  // Helper method for save() to verify that no mandatory fields are missing
  // from the Map of currently filled entries. This needs to be called prior to
  // any backend API calls to avoid the case where some forms get inserted into the
  // database before aborting due to do unfilled entires.
  // Treats both null values and empty strings as a missing field
  //
  // returns: list of fields that needed to be filled but were empty
  // if return value has lengthq == 0, we can proceed
  List<String> _validateFieldEntries(Map<String, String> fields) {
    _logger?.info("Save - Validating Fields");
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

      // Only validate this section if the user has filled at least one field in it
      final hasAnyFilledField = fields.entries
          .where((e) => e.key.startsWith('$section-'))
          .any((e) => e.value.trim().isNotEmpty);
      // skip if untouched
      if (!hasAnyFilledField) continue;

      for (final field in required) {
        final key = '$section-$field';
        if ((fields[key] ?? '').trim().isEmpty) {
          result.add("${key.split('-').first}: $field");
        }
      }
    }

    return result;
  }
}
