import 'package:bloc/bloc.dart';
import 'package:search_cms/features/authentication/presentation/bloc/home_state.dart';

/*
  State management class for the Home page
  For details of what cubit is,
  please read https://bloclibrary.dev/bloc-concepts/#cubit
 */
class HomeCubit extends Cubit<HomeState> {

  // Constructor
  HomeCubit() : super(const HomeInitial());

  /* */
  void reset() => emit(const HomeInitial());
}
