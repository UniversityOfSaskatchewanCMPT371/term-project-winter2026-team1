/*
  Domain representation of a combined row of archaeological data 
  to be displayed in the homepage data table.

  An valid row represents a joined view across Site, Area, Unit, Level, 
  Assemblage, and Artifact_Faunal tables.
  
  Identified by:
  - borden: Unique archaeological code
  - siteName: Site name (can be empty). This is typically represented by the borden
  - areaName: Area name
  - unitName: Unit name
  - levelName: Level name
  - upLimit: Upper depth limit
  - lowLimit: Lower depth limit
  - assemblageName: Assemblage name
  - porosity: Porosity of an artifact
  - sizeUpper: Upper size of an artifact. Typically measured in mm/cm
  - sizeLower: Lower size of an artifact. Typically measured in mm/cm
  - comment: Any additional comments about the artifact
  - preExcavFrags: Number of pre excavation fragments in an artifact
  - postExcavFrags: Number of post excavation fragments in an artifact
  - elements: Number of elements in an artifact

  Invariants:
  - borden must be a non-empty string
  - siteName may be empty but must not be null
  - areaName must be a non-empty string
  - unitName must be a non-empty string
  - levelName must be a non-empty string
  - upLimit <= lowLimit
  - assemblageName must be a non-empty string
  - porosity is null or between 1-5
  - If sizeUpper and sizeLower are not null, then sizeUpper >= sizeLower
  - comment may be empty but must not be null
  - preExcavFrags > 0
  - postExcavFrags > 0
  - elements > 0
*/

class TableRowEntity {
  final String borden;
  final String siteName;
  final String areaName;
  final String unitName;
  final String levelName;
  final int upLimit;
  final int lowLimit;
  final String assemblageName;
  final int? porosity;
  final double? sizeUpper;
  final double? sizeLower;
  final String comment;
  final int preExcavFrags;
  final int postExcavFrags;
  final int elements;

TableRowEntity({
  required this.borden,
  required this.siteName,
  required this.areaName,
  required this.unitName,
  required this.levelName,
  required this.upLimit,
  required this.lowLimit,
  required this.assemblageName,
  this.porosity,
  this.sizeUpper,
  this.sizeLower,
  required this.comment,
  required this.preExcavFrags,
  required this.postExcavFrags,
  required this.elements,
})
: assert(borden.isNotEmpty),
  assert(areaName.isNotEmpty),
  assert(unitName.isNotEmpty),
  assert(levelName.isNotEmpty),
  assert(upLimit <= lowLimit),
  assert(porosity == null || (porosity > 0 && porosity <= 5)),
  assert(sizeUpper == null || sizeLower == null || sizeUpper >= sizeLower),
  assert(preExcavFrags > 0),
  assert(postExcavFrags > 0),
  assert(elements > 0);
}



