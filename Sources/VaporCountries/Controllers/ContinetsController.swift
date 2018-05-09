import Vapor
import Fluent

extension Continent : Parameter{}
extension Continent : Content{}

public final class ContinentsController<D>: RouteCollection where D: QuerySupporting, D: IndexSupporting  {
  
  public typealias Database = D
  
  public func boot(router: Router) throws {
    let aRoute = router.grouped("api", "continets")
    
    //GET /api/continets
    aRoute.get(use: getAllHandler)
    
    //GET /api/continets/:ID
    aRoute.get(Continent<D>.parameter as PathComponentsRepresentable, use: getOneHandler)
    
    //GET /api/continents/:continentID/countries
    aRoute.get(Continent<D>.parameter, "countries", use: getCountriesHandler)
  }
  
  //MARK: Handlers -
  
  func getAllHandler(_ req: Request) throws -> Future<[Continent<D>]> {
    return Continent<D>.query(on: req).all()
  }
  
  func getOneHandler(_ req: Request) throws -> Future<Continent<D>> {
    return try req.parameters.next(Continent<D>.self)
  }
  
  //MARK: Children Handler -
  
  func getCountriesHandler(_ req: Request) throws -> Future<[Country<D>]> {
    return try req.parameters.next(Continent<Database>.self).flatMap(to: [Country<D>].self) { continent in
      return try continent.countries.query(on: req).all()
    }
  }
  
  //MARK: Paginated Handlers -
  
  func getAllPaginatedHandler(_ req: Request) throws -> Future<[Continent<D>]> {
    return Continent<D>.query(on: req).all()
  }
  
  func getCountriesPaginatedHandler(_ req: Request) throws -> Future<[Country<Database>]> {
    return try req.parameters.next(Continent<Database>.self).flatMap(to: [Country<Database>].self) { continent in
      return try continent.countries.query(on: req).paginate(on: req).all()
    }
  }
  
}




