//
//  ShowsViewModel.swift
//  TVMazeApp
//
//  Created by marcos.brito on 05/09/21.
//

import Combine

public protocol ShowsViewModelProtocol: ObservableObject {
    typealias FetchShowsByPage = (Int) -> AnyPublisher<[Show], DomainError>
    typealias FetchShowById = (Int) -> AnyPublisher<Show, DomainError>

    var state: ShowsState { get }
    var shows: [Show] { get }
    var page: Int { get }

    func onAppear()
    func nextPageIdNeeded(_ currentPosition: Int)
    func open(show: Show)
}

public final class ShowsViewModel: ShowsViewModelProtocol {

    private let fetchShowsByPage: FetchShowsByPage
    private let fetchShowById: FetchShowById
    private var cancellables = Set<AnyCancellable>()

    @Published public var state: ShowsState = .idle
    @Published public var shows: [Show] = []
    public var page: Int = 0

    public init(
        fetchShowsByPage: @escaping FetchShowsByPage,
        fetchShowById: @escaping FetchShowById
    ) {
        self.fetchShowsByPage = fetchShowsByPage
        self.fetchShowById = fetchShowById

    }

    public func onAppear() {
        state = .loading
        fetchShows(page: page)
    }

    public func nextPageIdNeeded(_ currentPosition: Int) {
        guard currentPosition > shows.count - 8 else {
            return
        }
        page += 1
        fetchShows(page: page)
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

    private func fetchShows(page: Int) {
        fetchShowsByPage(page).sink { [weak self] result in
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
}
