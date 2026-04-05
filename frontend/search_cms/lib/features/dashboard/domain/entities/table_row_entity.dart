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
  - Any combination of fields may be present; no single field is required
  - All fields are strings; null model fields are converted to '' before construction
  - porosity, sizeUpper, sizeLower remain nullable (absent means no value)
  - If upLimit and lowLimit are both non-empty valid integers, upLimit <= lowLimit
  - porosity is null or a valid integer between 1-5
  - If sizeUpper and sizeLower are both non-null valid numbers, sizeUpper >= sizeLower
  - preExcavFrags, postExcavFrags, elements are '' or a valid integer > 0
*/

class TableRowEntity {

  // Site
  final String borden;
  final String siteName;

  // Area
  final String areaName;

  // Unit
  final String unitName;

  // Level
  final String levelName;
  final String upLimit;
  final String lowLimit;

  // Assemblage
  final String assemblageName;

  // Artifact_Faunal
  final String? porosity;
  final String? sizeUpper;
  final String? sizeLower;
  final String comment;
  final String preExcavFrags;
  final String postExcavFrags;
  final String elements;

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
: assert(
    // if upLimit and lowLimit exist, assert upLimit <= lowLimit
    upLimit.isEmpty || lowLimit.isEmpty ||
    int.tryParse(upLimit) == null || int.tryParse(lowLimit) == null ||
    int.parse(upLimit) <= int.parse(lowLimit),
    'Up limit must be lower than low limit'
  ),
  assert(
    // if porosity exists, assert 1 <= porosity <= 5
    porosity == null ||
    (int.tryParse(porosity) != null && int.parse(porosity) > 0 && int.parse(porosity) <= 5),
    'Porosity must be between 1-5'
  ),
  assert(
    // if sizeUpper and sizeLower exist, assert sizeUpper >= sizeLower
    sizeUpper == null || sizeLower == null ||
    double.tryParse(sizeUpper) == null || double.tryParse(sizeLower) == null ||
    double.parse(sizeUpper) >= double.parse(sizeLower),
    'Size upper must be greater than size lower'
  ),
  assert(
    // allows empty strings but rejects non-numberical, zero or negative values
    preExcavFrags.isEmpty || (int.tryParse(preExcavFrags) ?? -1) > 0,
    'There must be at least 1 pre excav frag'
  ),
  assert(
    // allows empty strings but rejects non-numberical, zero or negative values
    postExcavFrags.isEmpty || (int.tryParse(postExcavFrags) ?? -1) > 0,
    'There must be at least 1 post excav frag'
  ),
  assert(
    // allows empty strings but rejects non-numberical, zero or negative values
    elements.isEmpty || (int.tryParse(elements) ?? -1) > 0,
    'There must be at least 1 element'
  );
}


