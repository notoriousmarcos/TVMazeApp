//
//  WebChannelTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 02/09/21.
//

import XCTest
@testable import TVMazeApp

class WebChannelTests: XCTestCase {

    func testTVWebChannel_codable_ShouldEncodeAndDecodeWebChannel() throws {
        // Arrange
        let sut = WebChannel(
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
        let decodedValue = try decoder.decode(WebChannel.self, from: data)

        // Assert
        XCTAssertEqual(sut, decodedValue)
    }
}
