import '../../../../core/utils/class_templates/result.dart';

abstract class AbstractAreaInsertRepository {
  /*
    The repository function for inserting a new area into Supabase

    @param name A String containing the name of the area. Must not be empty.
    @return A Success if insert is successful, containing the AreaEntity or
      Failure containing the errorMessage otherwise

    Preconditions: name.isNotEmpty
    Postconditions: A Result children class Success or Failure will be returned
   */
  Future<Result> insertArea(String name);
}
