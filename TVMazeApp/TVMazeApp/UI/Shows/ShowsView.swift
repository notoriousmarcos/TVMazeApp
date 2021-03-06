//
//  ShowsView.swift
//  TVMazeApp
//
//  Created by marcos.brito on 05/09/21.
//

import Combine
import SwiftUI

struct ShowsView<ShowsModel: ShowsViewModelProtocol, ShowDetailViewModel: ShowDetailViewModelProtocol>: View {
    @ObservedObject var viewModel: ShowsModel
    var openShow: (Show) -> ShowDetailView<ShowDetailViewModel>

    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            switch viewModel.state {
                case .idle:
                    Color.clear
                case .loading:
                    loadingView()
                default:
                    list(of: viewModel.shows)
                        .navigationBarTitle("Shows", displayMode: .large)
            }

        }.onAppear(perform: {
            viewModel.onAppear()
        })
    }

    private func list(of shows: [Show]) -> some View {
        let showsWithIndex = shows.enumerated().map { $0 }
        return List(showsWithIndex, id: \.element.id) { index, show in
            NavigationLink(
                destination: openShow(show),
                label: {
                    ShowCell(model: show)
                        .onAppear(perform: {
                        viewModel.nextPageIdNeeded(index)
                    })
                }
            )
        }
    }

    private func loadingView() -> some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .primary))
            .scaleEffect(1)
            .padding()
    }
}

struct ShowsView_Previews: PreviewProvider {
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
        return ShowsView<ShowsViewModel, ShowDetailViewModel>(
            viewModel: ShowsViewModel(
                fetchShowsByPage: { _ -> AnyPublisher<[Show], DomainError> in
                    return Just([show])
                        .setFailureType(to: DomainError.self)
                        .eraseToAnyPublisher()
                }
            ), openShow: { show in
                ShowDetailView(
                    viewModel: ShowDetailViewModel(
                        show: show,
                        fetchShowById: { _ -> AnyPublisher<Show, DomainError> in
                            return Just(show)
                                .setFailureType(to: DomainError.self)
                                .eraseToAnyPublisher()
                        },
                        fetchEpisodesByShow: { _ -> AnyPublisher<[Episode], DomainError> in
                            return Just([])
                                .setFailureType(to: DomainError.self)
                                .eraseToAnyPublisher()
                        }
                    )
                )
            }
        )
    }
}
