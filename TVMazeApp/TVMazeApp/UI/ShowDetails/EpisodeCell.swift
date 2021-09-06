//
//  EpisodeCell.swift
//  TVMazeApp
//
//  Created by marcos.brito on 05/09/21.
//

import SwiftUI

struct EpisodeCell: View {
    var model: Episode

    var body: some View {
        HStack(spacing: 8) {
            if let showImageURL = URL(string: model.image?.medium ?? "") {
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
                Text(model.summary ?? "")
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
}

struct EpisodeCell_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeCell(
            model: Episode(
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
        ).previewLayout(.sizeThatFits)
    }
}
