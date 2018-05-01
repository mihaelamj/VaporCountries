#if Xcode
import Async
import Fluent
import Foundation

//TODO: add parent property (continent)

public final class Country<D>: Model where D: QuerySupporting, D: IndexSupporting {
  
  public typealias Database = D
  
  public typealias ID = Int
  
  public static var idKey: IDKey { return \.id }
  
  public static var entity: String {
    return "country"
  }
  
  public static var database: DatabaseIdentifier<D> {
    return .init("countries")
  }
  
  var id: Int?
  var name: String
  var numeric: String
  var alpha2: String
  var alpha3: String
  var calling: String
  var currency: String
  var continentID: Continent<Database>.ID
  
  init(name : String, numeric: String, alpha2: String, alpha3: String, calling: String, currency: String, continentID: Continent<Database>.ID) {
    self.name = name
    self.numeric = numeric
    self.alpha2 = alpha2
    self.alpha3 = alpha3
    self.calling = calling
    self.currency = currency
    self.continentID = continentID
  }
}

extension Country: Migration where D: QuerySupporting, D: IndexSupporting, D: ReferenceSupporting { }

// MARK: Relations

////Country ⇇↦  Continent
extension Country {
  /// A relation to this country's continent.
  var owner: Parent<Country, Continent<Database>>? {
    return parent(\.continentID)
  }
}

//MARK: - Populating data

internal struct CountryMigration<D>: Migration where D: QuerySupporting & SchemaSupporting & IndexSupporting & ReferenceSupporting {
  
  typealias Database = D
  
//MARK: - Create Fields, Indexes and relations
  
  static func prepareFields(on connection: Database.Connection) -> Future<Void> {
    return Database.create(Country<Database>.self, on: connection) { builder in
      
      //add fields
      try builder.field(for: \Country<Database>.id)
      try builder.field(for: \Country<Database>.name)
      try builder.field(for: \Country<Database>.numeric)
      try builder.field(for: \Country<Database>.alpha2)
      try builder.field(for: \Country<Database>.alpha3)
      try builder.field(for: \Country<Database>.calling)
      try builder.field(for: \Country<Database>.currency)
      try builder.field(for: \Country<Database>.continentID)
      
      //indexes
      try builder.addIndex(to: \.name, isUnique: true)
      try builder.addIndex(to: \.alpha2, isUnique: true)
      try builder.addIndex(to: \.alpha3, isUnique: true)
      
      //referential integrity - foreign key to parent
      try builder.addReference(from: \Country<D>.continentID, to: \Continent<D>.id, actions: .init(update: .update, delete: .nullify))
    }
  }
  
  //MARK: - Helpers
  
  static func getContinentID(on connection: Database.Connection, continentAlpha2: String) -> Future<Continent<Database>.ID> {
    do {
      return try Continent<D>.query(on: connection)
        .filter(\Continent.alpha2, .equals, .data(continentAlpha2))
        .first()
        .map(to: Continent<Database>.ID.self) { continent in
          guard let continent = continent else {
            throw FluentError(
              identifier: "PopulateCountries_noSuchContinent",
              reason: "No continent (with alpha2) \(continentAlpha2) exists!",
              source: .capture()
            )
          }
          return continent.id!
      }
    }
    catch {
      return connection.eventLoop.newFailedFuture(error: error)
    }
  }
  
  static func addCountries(on connection: Database.Connection, toContinentWithAlpha2 continentAlpha2: String, countries: [(name:String, numeric: String, alpha2:String, alpha3: String, calling:String, currency: String, continent:String)]) -> Future<Void> {
    
    return getContinentID(on: connection, continentAlpha2: continentAlpha2)
      .flatMap(to: Void.self) { continentID in
        
        let futures = countries.map { touple -> EventLoopFuture<Void> in
          let name = touple.0
          let numeric = touple.1
          let alpha2 = touple.2
          let alpha3 = touple.3
          let calling = touple.4
          let currency = touple.5
          
          return Country<Database>(name: name, numeric: numeric, alpha2: alpha2, alpha3: alpha3, calling: calling, currency: currency, continentID:continentID )
            .create(on: connection)
            .map(to: Void.self) { _ in return }
        }
        
        return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
    }
  }
  
  static func deleteCountries(on connection: Database.Connection, forContinentWithAlpha2 continentAlpha2: String, countries: [(name:String, numeric: String, alpha2:String, alpha3: String, calling:String, currency: String, continent:String)]) -> Future<Void> {
    
    return getContinentID(on: connection, continentAlpha2: continentAlpha2)
      .flatMap(to: Void.self) { continentID in
        
        let futures = try countries.map { touple -> EventLoopFuture<Void> in
          
          let name = touple.0
          
          return try Country<D>.query(on: connection)
            .filter(\Country.continentID, .equals, .data(continentID))
            .filter(\Country.name, .equals, .data(name))
            .delete()
        }
        return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
    }
  }
  
  static func prepareAddCountries(on connection: Database.Connection) -> Future<Void> {
    let futures = countries.map { continentAlpha2, countryTouples in
      return addCountries(on: connection, toContinentWithAlpha2: continentAlpha2, countries: countryTouples)
    }
    return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
  }
  
  //MARK: - Required
  
  static func prepare(on connection: Database.Connection) -> Future<Void> {
    let futureCreateFields = prepareFields(on: connection)
    let futureInsertData = prepareAddCountries(on: connection)
    
    let allFutures : [EventLoopFuture<Void>] = [futureCreateFields, futureInsertData]
    
    return Future<Void>.andAll(allFutures, eventLoop: connection.eventLoop)
  }
  
  static func revert(on connection: D.Connection) -> EventLoopFuture<Void> {
    let futures = countries.map { continentAlpha2, countryTouples in
      return deleteCountries(on: connection, forContinentWithAlpha2: continentAlpha2, countries: countryTouples)
    }
    return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
  }

}
#endif

