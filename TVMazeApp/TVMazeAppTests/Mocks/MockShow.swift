//
//  MockShow.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 04/09/21.
//

import Foundation
@testable import TVMazeApp

struct MockShow {
    static let valid = Show(
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
        summary: "<p>Based on the critically acclaimed...</p>",
        updated: 1603936716,
        links: ShowLink(
            current: Link(
                href: "https://api.tvmaze.com/shows/3"
            ),
            previousepisode: Link(
                href: "https://api.tvmaze.com/episodes/631862"
            )
        ))
}
