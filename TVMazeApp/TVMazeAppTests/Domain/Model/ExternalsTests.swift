//
//  ExternalsTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 01/09/21.
//

import XCTest
@testable import TVMazeApp

class ExternalsTests: XCTestCase {

    func testExternals_codable_ShouldEncodeAndDecodeExternals() throws {
        // Arrange
        let sut = Externals(
            tvrage: 25988,
            thetvdb: 264492,
            imdb: "tt1553656"
        )
        let decoder = JSONDecoder()

        // Act
        guard let data = sut.toData() else {
            XCTFail("Should return a valid data.")
            return
        }
        let decodedValue = try decoder.decode(Externals.self, from: data)

        // Assert
        XCTAssertEqual(sut, decodedValue)
    }

}
