//
//  ScheduleTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 01/09/21.
//

import XCTest
@testable import TVMazeApp

class ScheduleTests: XCTestCase {

    func testSchedule_codable_ShouldEncodeAndDecodeSchedule() throws {
        // Arrange
        let sut = Schedule(time: "22:00", days: ["Tuesday"])
        let decoder = JSONDecoder()

        // Act
        guard let data = sut.toData() else {
            XCTFail("Should return a valid data.")
            return
        }
        let decodedValue = try decoder.decode(Schedule.self, from: data)

        // Assert
        XCTAssertEqual(sut, decodedValue)
    }

}
