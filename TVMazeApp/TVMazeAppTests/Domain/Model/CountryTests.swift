//
//  CountryTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 01/09/21.
//

import XCTest
@testable import TVMazeApp

class CountryTests: XCTestCase {

    func testCountry_codable_ShouldEncodeAndDecodeCountry() throws {
        // Arrange
        let sut = Country(
            name: "United States",
            code: "US",
            timezone: "America/New_York"
        )
        let decoder = JSONDecoder()

        // Act
        guard let data = sut.toData() else {
            XCTFail("Should return a valid data.")
            return
        }
        let decodedValue = try decoder.decode(Country.self, from: data)

        // Assert
        XCTAssertEqual(sut, decodedValue)
    }

}
