//
//  ShowsViewModel.swift
//  TVMazeApp
//
//  Created by marcos.brito on 05/09/21.
//

import Combine

public protocol SearchShowsViewModelProtocol: ObservableObject {
    typealias FindShows = (String) -> AnyPublisher<[Show], DomainError>
    typealias FetchShowById = (Int) -> AnyPublisher<Show, DomainError>

    var state: ShowsState { get }
    var shows: [Show] { get }

    func search(_ search: String)
    func open(show: Show)
}

public final class SearchShowsViewModel: SearchShowsViewModelProtocol {

    private let findShows: FindShows
    private let fetchShowById: FetchShowById
    private var cancellables = Set<AnyCancellable>()

    @Published public var state: ShowsState = .idle
    @Published public var shows: [Show] = []

    public init(
        findShows: @escaping FindShows,
        fetchShowById: @escaping FetchShowById
    ) {
        self.findShows = findShows
        self.fetchShowById = fetchShowById

    }

    public func search(_ search: String) {
        state = .loading
        findShows(search).sink { [weak self] result in
            switch result {
                case .failure(let error):
                    self?.state = .error(message: error.localizedDescription)
                case .finished:
                    break
            }
        } receiveValue: { [weak self] shows in
            self?.shows += shows
            self?.state = .loaded(shows: shows)
        }.store(in: &cancellables)
    }

    public func open(show: Show) {
        state = .loading
        fetchShowById(show.id).sink { [weak self] result in
            switch result {
                case .failure(let error):
                    self?.state = .error(message: error.localizedDescription)
                case .finished:
                    break
            }
        } receiveValue: { [weak self] show in
            self?.state = .open(show: show)
        }.store(in: &cancellables)
    }
}
