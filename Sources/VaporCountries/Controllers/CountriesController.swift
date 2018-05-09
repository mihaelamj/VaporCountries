import Vapor
import Fluent

extension Country : Parameter{}
extension Country : Content{}

public final class CountriesController<D>: RouteCollection where D: QuerySupporting, D: IndexSupporting  {
  
  public typealias Database = D
  
  public func boot(router: Router) throws {
    let aRoute = router.grouped("api", "countries")
    
    //GET /api/countries
    aRoute.get(use: getAllHandler)
    
    //GET /api/countries/:ID
    aRoute.get(Country<D>.parameter as PathComponentsRepresentable, use: getOneHandler)
    
    //GET /api/countries/:ID/continent
    aRoute.get(Country<D>.parameter as PathComponentsRepresentable, "continent", use: getContinentHandler)
  }
  
  //MARK: Handlers -
  
  func getAllHandler(_ req: Request) throws -> Future<[Country<D>]> {
    return Country<D>.query(on: req).all()
  }
  
  func getOneHandler(_ req: Request) throws -> Future<Country<D>> {
    return try req.parameters.next(Country<D>.self)
  }
  
  //MARK: Parent Handler -
  
  func getContinentHandler(_ req: Request) throws -> Future<Continent<D>> {
    return try req.parameters.next(Country<D>.self).flatMap(to: Continent<D>.self) { country in
      return try country.continent!.get(on: req)
    }
  }
  
  //MARK: Paginated Handlers -
  
  //GET http://localhost:8080/api/countries?limit=20&page=1
  func getAllPaginatedHandler(_ req: Request) throws -> Future<[Country<D>]> {
    return try Country<D>.query(on: req).paginate(on: req).all()
  }
  
}
