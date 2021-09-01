//
//  ModelTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 01/09/21.
//

import XCTest
@testable import TVMazeApp

class ModelTests: XCTestCase {

    func testModel_codable_ShouldEncodeAndDecodeMockModel() throws {
        // Arrange
        let sut = MockModel(value: "string")
        let decoder = JSONDecoder()

        // Act
        guard let data = sut.toData() else {
            XCTFail("Should return a valid data.")
            return
        }
        let decodedValue = try decoder.decode(MockModel.self, from: data)

        // Assert
        XCTAssertEqual(sut, decodedValue)
    }

    private struct MockModel: Model {
        let value: String
    }
}
