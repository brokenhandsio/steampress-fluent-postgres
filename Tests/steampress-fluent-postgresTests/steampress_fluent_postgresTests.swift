import XCTest
@testable import steampress_fluent_postgres

final class steampress_fluent_postgresTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(steampress_fluent_postgres().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
