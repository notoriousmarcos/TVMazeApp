//
//  ShowImageTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 01/09/21.
//

import XCTest
@testable import TVMazeApp

public struct ShowImage: Model {
    let medium: String
    let original: String
}

class ShowImageTests: XCTestCase {

    func testShowImage_codable_ShouldEncodeAndDecodeShowImage() throws {
        // Arrange
        let sut = ShowImage(
            medium: "https://static.tvmaze.com/uploads/images/medium_portrait/81/202627.jpg",
            original: "https://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg"
        )
        let decoder = JSONDecoder()

        // Act
        guard let data = sut.toData() else {
            XCTFail("Should return a valid data.")
            return
        }
        let decodedValue = try decoder.decode(ShowImage.self, from: data)

        // Assert
        XCTAssertEqual(sut, decodedValue)
    }
}
