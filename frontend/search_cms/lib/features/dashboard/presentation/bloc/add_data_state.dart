import 'package:equatable/equatable.dart';

sealed class AddDataState extends Equatable {
  const AddDataState();

  @override
  List<Object?> get props => [];
}

// Initial state before the page takes to its loading state
class AddDataInitial extends AddDataState {
  const AddDataInitial();

}

// Adding a loading state for the add data page
// The page is in a loading state
class AddDataLoading extends AddDataState {
  const AddDataLoading();
}

//Loaded state for the the add data page
//Makes sure that the Add Data page is fully loaded
class AddDataLoaded extends AddDataState {

  //Stores typed valued for each state for each specific column/field
  //Field values can now be stored
  final Map<String, String> fieldValues;

  const AddDataLoaded({
    this.fieldValues = const {},
  });

  @override
  List<Object> get props => [fieldValues];
}