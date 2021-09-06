//
//  ShowsDetailsView.swift
//  TVMazeApp
//
//  Created by marcos.brito on 06/09/21.
//

import Combine
import SwiftUI

struct ShowDetailView<Model>: View where Model: ShowDetailViewModelProtocol {
    @ObservedObject var viewModel: Model
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            switch viewModel.state {
                case .idle:
                    Color.clear
                case .loading:
                    loadingView()
                default:
                    list(of: viewModel.episodes, forShow: viewModel.show)
                        .navigationBarTitle("Shows", displayMode: .large)
            }

        }.onAppear(perform: {
            viewModel.onAppear()
        })
    }

    func showHeader(_ show: Show) -> some View {
        VStack {
            if let showImageURL = URL(string: show.image.medium) {
                AsyncImage(
                    url: showImageURL,
                    placeholder: { Text("Loading...") },
                    image: { Image(uiImage: $0).resizable() }
                )
                .frame(idealHeight: 300, alignment: .center)
            }
            Text(show.name)
                .font(.title)
            Divider().background(Color.white)
            Text(show.summary)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(50)
        }.padding()
        .navigationBarTitle(Text(show.name), displayMode: .inline)
    }

    private func list(of episodes: [Episode], forShow show: Show) -> some View {
        return List {
            Section(header: showHeader(show)) {
                ForEach(episodes, id: \.id) { episode in
                    EpisodeCell(model: episode)
                }
            }
        }
    }

    private func loadingView() -> some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .primary))
            .scaleEffect(1)
            .padding()
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

struct ShowsDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let show = Show(
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
            )
        )

        let episode = Episode(
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

        return ShowDetailView(
            viewModel: ShowDetailViewModel(
                show: show,
                fetchShowById: { _ -> AnyPublisher<Show, DomainError> in
                    return Just(show)
                        .setFailureType(to: DomainError.self)
                        .eraseToAnyPublisher()
                },
                fetchEpisodesByShow: { _ -> AnyPublisher<[Episode], DomainError> in
                    return Just([episode])
                        .setFailureType(to: DomainError.self)
                        .eraseToAnyPublisher()
                }
            )
        )
    }
}
