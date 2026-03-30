import 'package:equatable/equatable.dart';

// A base class for the Add Data page
// 
// preconditions:
// - None
// postconditions:
// - The Add data page states that eventually will extend from this class
sealed class AddDataState extends Equatable {
  const AddDataState();

  @override
  List<Object?> get props => [];
}

// Initial state before the page takes to its loading state
// 
//preconditions:
// - tbe cubit state has been created
// 
//postconditions:
// - the page starts in the initial state
class AddDataInitial extends AddDataState {
  const AddDataInitial();

}

// Adding a loading state for the add data page
// The page is in a loading state
//
//preconditions:
// - The page has started the loading state
// 
//postconditions:
// - The page is in a loading state
class AddDataLoading extends AddDataState {
  const AddDataLoading();
}

//Loaded state for the the add data page
//Makes sure that the Add Data page is fully loaded
//
//preconditions:
// - The page has completed the loading state
//
//postconditions:
// - The fieldvalues can be stored into the input-values
class AddDataLoaded extends AddDataState {

  //Stores typed valued for each state for each specific column/field
  //Field values can now be stored
  final Map<String, String> fieldValues;

  //the loaded states contains the fieldvalues
  const AddDataLoaded({
    this.fieldValues = const {},
  });

  @override
  List<Object> get props => [fieldValues];
}

// State to register that the save button has been pressed
// Displays a small loading icon while the backend is processing the call
class SaveLoading extends AddDataState {
  const SaveLoading();
}

// State to register when a save is successful
class SaveSuccess extends AddDataState {
  const SaveSuccess();
}

// State to register when a save call has failed
class SaveFailure extends AddDataState {
  final String message;

  const SaveFailure(this.message);

  @override
  List<Object?> get props => [message];
}