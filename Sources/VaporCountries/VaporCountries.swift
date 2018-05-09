import Foundation
import Fluent

extension MigrationConfig {
  public mutating func addVaporCountries<D>(for database: DatabaseIdentifier<D>) where D: QuerySupporting & SchemaSupporting & IndexSupporting & ReferenceSupporting {
    Continent<D>.defaultDatabase = database
    self.add(migration: ContinentMigration<D>.self, database: database)
    Country<D>.defaultDatabase = database
    self.add(migration: CountryMigration<D>.self, database: database)
  }
}
