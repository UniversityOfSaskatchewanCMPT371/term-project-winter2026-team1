# Test Matrix

**Last Updated**: 2026-01-21

## Legend
 - Y = Planned
 - X = Ommitted or unplanned

## Notes
 - High risk features must be tested at all levels


## Matrix
| Feature / Requirement | Risk Level | Unit | Integration | System | Manual | Notes         |
|-----------------------|------------|------|-------------|--------|--------|---------------|
| Data Sync             | High       | Y    | Y           | Y      |  Y     | Verifying Powersync |
| Querying DB           | High       | Y    | Y           | Y      |  Y     | |
| Adding Data Entries   | High       | Y    | Y           | Y      |  Y     | |
| Update Existing Entry | Medium     | Y    | Y           | X      |  Y     | May be added later |
| Delete / Archive Entry | Low       | Y    | Y           | X      | Y      | Policy TBD |
| Schema Validation     | High       | Y    | Y           | X      | X      | Prevent malformed records |
| Data Consistency      | High       | X    | Y           | Y      | Y      | Across queries & views |
| Error Handling        | Medium     | Y    | X           | Y      | Y      | User-visible failures |
