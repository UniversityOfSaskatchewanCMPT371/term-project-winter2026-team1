/*
  Domain representation of an Artifact in the archaeological system.

  An Artifact is found in an Assemblage and is identified by:
  - id: UUID string
  - assemblageId: UUID string of the assemblage it belongs to
  - porosity: Porosity of the artifact
  - sizeUpper: Upper size of the artifact. Typically measured in mm/cm
  - sizeLower: Lower size of the artifact. Typically measured in mm/cm
  - comment: Any additional comments
  - preExcavFrags: Number of pre excavation fragments in the artifact
  - postExcavFrags: Number of post excavation fragments in the artifact
  - elements: Number of elements in the artifact
  - createdAt: Timestamp of creation
  - updatedAt: Timestamp of last modification

  Invariants:
  - id must be a non-empty UUID string
  - assemblageId must be a non-empty UUID string
  - porosity must be null or between 1-5
  - sizeUpper can be non-empty or empty
  - sizeLower can be non-empty or empty
  - sizeUpper >= sizeLower
  - comment can be non-empty or empty
  - preExcavFrags cannot be empty and will default to 1
  - postExcavFrags cannot be empty and will default to 1
  - elements cannot be empty and will default to 1
*/

class ArtifactFaunalEntity {
  final String id;
  final String assemblageId;
  final int? porosity;
  final double? sizeUpper;
  final double? sizeLower;
  final String comment;
  final int preExcavFrags;
  final int postExcavFrags;
  final int elements;
  final DateTime createdAt;
  final DateTime updatedAt;

  ArtifactFaunalEntity({
    required this.id,
    required this.assemblageId,
    this.porosity,
    this.sizeUpper,
    this.sizeLower,
    required this.comment,
    required this.preExcavFrags,
    required this.postExcavFrags,
    required this.elements,
    required this.createdAt,
    required this.updatedAt,
  })
  : assert(id.isNotEmpty),
    assert(assemblageId.isNotEmpty),
    assert(porosity == null || (porosity > 0 && porosity <= 5)),
    assert(sizeUpper == null || sizeLower == null || sizeUpper >= sizeLower),
    assert(preExcavFrags >= 0),
    assert(postExcavFrags >= 0),
    assert(elements >= 0);
}

