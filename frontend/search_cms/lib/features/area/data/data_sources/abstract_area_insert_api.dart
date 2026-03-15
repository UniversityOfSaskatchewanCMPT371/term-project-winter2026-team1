import '../models/area_model.dart';

abstract class AbstractAreaInsertApi {

  /*
    The api function for inserting a new area into Supabase

    @param name A String containing the name of the area. Must not be empty.
    @return An AreaModel instance if insert is successful or null otherwise

    Preconditions: name.isNotEmpty
   */
  Future<AreaModel?> insertArea(String name);
}
