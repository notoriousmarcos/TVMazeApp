//
//  EpisodeTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 01/09/21.
//

import XCTest
@testable import TVMazeApp

class EpisodeTests: XCTestCase {

    func testEpisode_codable_ShouldEncodeAndDecodeEpisode() throws {
        // Arrange
        let sut = Episode(
            id: 1,
            url: "https://www.tvmaze.com/episodes/1/under-the-dome-1x01-pilot",
            name: "Pilot",
            number: 1,
            season: 1,
            type: "regular",
            airdate: "2013-06-24",
            airtime: "22:00",
            airstamp: "2013-06-25T02:00:00+00:00",
            runtime: 60,
            summary: "<p>When the residents of Chester's Mill.</p>",
            image: ShowImage(
                medium: "https://static.tvmaze.com/uploads/images/medium_landscape/1/4388.jpg",
                original: "https://static.tvmaze.com/uploads/images/original_untouched/1/4388.jpg"
            ),
            links: ShowLink(
                current: Link(href: "https://api.tvmaze.com/episodes/1"),
                previousepisode: nil
            )
        )
        let decoder = JSONDecoder()

        // Act
        guard let data = sut.toData() else {
            XCTFail("Should return a valid data.")
            return
        }
        let decodedValue = try decoder.decode(Episode.self, from: data)

        // Assert
        XCTAssertEqual(sut, decodedValue)
    }

}
