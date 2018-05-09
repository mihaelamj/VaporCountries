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

import Vapor
import Routing

public func addVaporCountriesRoutes<D>(for database: DatabaseIdentifier<D>, router: Router) throws where D: QuerySupporting & IndexSupporting & ReferenceSupporting {
  let continetsController = ContinentsController<D>()
  try router.register(collection: continetsController)
  
  let countriesController = CountriesController<D>()
  try router.register(collection: countriesController)
}

