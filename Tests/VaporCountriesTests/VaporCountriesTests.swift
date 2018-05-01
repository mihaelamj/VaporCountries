import XCTest
@testable import VaporCountries

final class VaporCountriesTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(VaporCountries().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
