/*
  The abstract API interface for inserting a faunal artifact
*/
abstract class AbstractInsertArtifactApi {
  /*
    Inserts a new faunal artifact record into the database

    @param assemblageName: non-empty name of associated assemblage
    Optional parameters:
    @param porosity: int 1-5
    @param sizeUpper: lower bound of tuple
    @param sizeLower: upper bound of same tuple
    @param comment: string comment
    @param preExcavFrags: integer, default is 1
    @param postExcavFrags: integer, default is 1
    @param elements: integer, default to 1

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) assemblageName.isNotEmpty && sizeUpper <= sizeLower if non-null

    Postconditions: new artifact record is inserted into the database
  */
  Future<void> insertArtifact({
    required String assemblageName,
    int? porosity,
    int? sizeUpper,
    int? sizeLower,
    String? comment,
    int? preExcavFrags,
    int? postExcavFrags,
    int? elements});
}
