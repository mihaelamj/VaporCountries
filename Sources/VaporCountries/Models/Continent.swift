#if Xcode
import Async
import Fluent
import Foundation

public final class Continent<D>: Model where D: QuerySupporting, D: IndexSupporting {
  
  public typealias Database = D
  public typealias ID = Int
  public static var idKey: IDKey { return \.id }
  public static var entity: String {
    return "continent"
  }
  public static var database: DatabaseIdentifier<D> {
    return .init("continent")
  }
  
  var id: Int?
  var name: String
  var alpha2: String
  
  init(name: String, alpha2: String) {
    self.name = name
    self.alpha2 = alpha2
  }
}

extension Continent: Migration where D: QuerySupporting, D: IndexSupporting { }

//Continent ↤⇉ Country
extension Continent {
  var countries: Children<Continent, Country<Database>> {
    return children(\.continentID)
  }
}

//MARK: - Populating data

let continents : [[String: String]] = [
  ["name": "Africa", "alpha2": "AF"],
  ["name": "Antarctica", "alpha2": "AN"],
  ["name": "Asia", "alpha2": "AS"],
  ["name": "Europe", "alpha2": "EU"],
  ["name": "North America", "alpha2": "NA"],
  ["name": "Oceania", "alpha2": "OC"],
  ["name": "South America", "alpha2": "SA"],
  ["name": "Nothing", "alpha2": "NN"]
]

internal struct ContinentMigration<D>: Migration where D: QuerySupporting & SchemaSupporting & IndexSupporting {
  typealias Database = D
  
  static func prepareFields(on connection: Database.Connection) -> Future<Void> {
    return Database.create(Continent<Database>.self, on: connection) { builder in
      
      //add fields
      try builder.field(for: \Continent<Database>.id)
      try builder.field(for: \Continent<Database>.name)
      try builder.field(for: \Continent<Database>.alpha2)
      
      //indexes
      try builder.addIndex(to: \.name, isUnique: true)
    }
  }
  
  static func prepareInsertData(on connection: Database.Connection) ->  Future<Void>   {
    let futures : [EventLoopFuture<Void>] = continents.map { continent in
      let name = continent["name"]!
      let alpha2 = continent["alpha2"]!
      return Continent<D>(name: name, alpha2: alpha2).create(on: connection).map(to: Void.self) { _ in return }
    }
    return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
  }
  
  static func prepare(on connection: Database.Connection) -> Future<Void> {
    
    let futureCreateFields = prepareFields(on: connection)
    let futureInsertData = prepareInsertData(on: connection)
    
    let allFutures : [EventLoopFuture<Void>] = [futureCreateFields, futureInsertData]
    
    return Future<Void>.andAll(allFutures, eventLoop: connection.eventLoop)
  }
  
  static func revert(on connection: Database.Connection) -> Future<Void> {
    do {
      // Delete all names
      let futures = try continents.map { continent -> EventLoopFuture<Void> in
        let alpha2 = continent["alpha2"]!
        return try Continent<D>.query(on: connection).filter(\Continent.alpha2, .equals, .data(alpha2)).delete()
      }
      return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
    }
    catch {
      return connection.eventLoop.newFailedFuture(error: error)
    }
  }
}
#endif
