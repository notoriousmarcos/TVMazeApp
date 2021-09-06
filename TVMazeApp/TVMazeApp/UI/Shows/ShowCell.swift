//
//  ShowCell.swift
//  TVMazeApp
//
//  Created by marcos.brito on 05/09/21.
//

import SwiftUI

struct ShowCell: View {
    var model: Show

    var body: some View {
        HStack(spacing: 8) {
            if let showImageURL = URL(string: model.image.medium) {
                AsyncImage(
                    url: showImageURL,
                    placeholder: { Text("Loading...") },
                    image: { Image(uiImage: $0).resizable() }
                )
                .frame(width: 100, height: 100, alignment: .center)
            }

            VStack(alignment: .leading) {
                Text(model.name)
                    .font(.headline)
                Text(model.summary)
                    .lineLimit(4)
                    .font(.subheadline)
            }
        }
        .padding(8)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.primary, lineWidth: 1)
        )
        .padding(8)

    }

    private func getSummary(_ summary: String) -> String {
        let data = summary.data(using: .utf8)!
        let attributtedSummary = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ).string

        return attributtedSummary ?? summary
    }
}

struct ShowCell_Previews: PreviewProvider {
    static var previews: some View {
        ShowCell(
            model: Show(
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
        ).previewLayout(.sizeThatFits)
    }
}
