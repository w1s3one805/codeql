/** Configurable extra restrictions on dataflow sources and sinks. */

private import codeql.util.Location

/** Extra restrictions on dataflow sources. */
extensible predicate restrictDataflowSourcesTo(string filePath, int startLine);

/** Extra restrictions on dataflow sinks. */
extensible predicate restrictDataflowSinksTo(string filePath, int startLine);

private predicate hasExtraDataflowSourceRestrictions() {
  exists(string filePath, int startLine | restrictDataflowSourcesTo(filePath, startLine))
}

private predicate hasExtraDataflowSinkRestrictions() {
  exists(string filePath, int startLine | restrictDataflowSinksTo(filePath, startLine))
}

module ExtraDataflowRestrictionsImpl<LocationSig Location> {
  bindingset[location]
  predicate allowSourceLocation(Location location) {
    not hasExtraDataflowSourceRestrictions()
    or
    exists(string filePath, int startLine |
      location.hasLocationInfo(filePath, startLine, _, _, _) and
      restrictDataflowSourcesTo(filePath, startLine)
    )
  }

  bindingset[location]
  predicate allowSinkLocation(Location location) {
    not hasExtraDataflowSinkRestrictions()
    or
    exists(string filePath, int startLine |
      location.hasLocationInfo(filePath, startLine, _, _, _) and
      restrictDataflowSinksTo(filePath, startLine)
    )
  }
}
