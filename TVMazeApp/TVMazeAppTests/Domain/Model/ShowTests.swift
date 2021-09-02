//
//  ShowTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 02/09/21.
//

import XCTest
@testable import TVMazeApp

class ShowTests: XCTestCase {
    
    func testShow_codable_ShouldEncodeAndDecodeShow() throws {
        // Arrange
        let sut = Show(
            id: 1,
            url: "https://www.tvmaze.com/shows/3/bitten",
            name: "Bitten",
            type: "Scripted",
            language: "English",
            genres: [
                "Drama",
                "Horror",
                "Romance"
            ],
            status: "Ended",
            runtime: 60,
            averageRuntime: 60,
            premiered: "2014-01-11",
            officialSite: "http://bitten.space.ca/",
            schedule: Schedule(
                time: "22:00",
                days: [
                    "Friday"
                ]),
            rating: Rating(average: 7.5),
            weight: 84,
            network: TVNetwork(
                id: 7,
                name: "CTV Sci-Fi Channel",
                country: Country(
                    name: "Canada",
                    code: "CA",
                    timezone: "America/Halifax")
            ),
            webChannel: nil,
            dvdCountry: nil,
            externals: Externals(
                tvrage: 34965,
                thetvdb: 269550,
                imdb: "tt2365946"
            ),
            image: ShowImage(
                medium: "https://static.tvmaze.com/uploads/images/medium_portrait/0/15.jpg",
                original: "https://static.tvmaze.com/uploads/images/original_untouched/0/15.jpg"
            ),
            summary: "<p>Based on the critically acclaimed series of novels from Kelley Armstrong. Set in Toronto and upper New York State, <b>Bitten</b> follows the adventures of 28-year-old Elena Michaels, the world's only female werewolf. An orphan, Elena thought she finally found her \"happily ever after\" with her new love Clayton, until her life changed forever. With one small bite, the normal life she craved was taken away and she was left to survive life with the Pack.</p>",
            updated: 1603936716,
            links: ShowLink(
                current: Link(
                    href: "https://api.tvmaze.com/shows/3"
                ),
                previousepisode: Link(
                    href: "https://api.tvmaze.com/episodes/631862"
                )
            ))
        let decoder = JSONDecoder()

        // Act
        guard let data = sut.toData() else {
            XCTFail("Should return a valid data.")
            return
        }
        let decodedValue = try decoder.decode(Show.self, from: data)

        // Assert
        XCTAssertEqual(sut, decodedValue)
    }
    
}
