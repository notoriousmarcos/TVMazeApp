//
//  NetworkTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 01/09/21.
//

import XCTest
@testable import TVMazeApp

class TVNetworkTests: XCTestCase {

    func testTVNetwork_codable_ShouldEncodeAndDecodeNetwork() throws {
        // Arrange
        let sut = TVNetwork(
            id: 1,
            name: "CBS",
            country: Country(
                name: "United States",
                code: "US",
                timezone: "America/New_York"
            ))
        let decoder = JSONDecoder()

        // Act
        guard let data = sut.toData() else {
            XCTFail("Should return a valid data.")
            return
        }
        let decodedValue = try decoder.decode(TVNetwork.self, from: data)

        // Assert
        XCTAssertEqual(sut, decodedValue)
    }
}
