import 'package:bloc/bloc.dart';
import 'add_data_state.dart';


//Add Data page state that uses a Manager function
class AddDataCubit extends Cubit<AddDataState> {
  AddDataCubit() : super(const AddDataInitial());

// Moves the Add Data Page to a loaded state
  void init() => emit(const AddDataLoaded());



