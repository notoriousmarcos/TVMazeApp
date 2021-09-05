//
//  ShowsViewModel.swift
//  TVMazeApp
//
//  Created by marcos.brito on 05/09/21.
//

import Combine

public protocol ShowsViewModelProtocol: ObservableObject {
    typealias FindShows = (String) -> AnyPublisher<[Show], DomainError>
    typealias FetchShowsByPage = (Int) -> AnyPublisher<[Show], DomainError>
    typealias FetchShowById = (Int) -> AnyPublisher<Show, DomainError>

    var state: ShowsState { get }
    var page: Int { get }

    func onAppear()
    func nextPage()
    func search(_ search: String)
    func open(show: Show)
}

public final class ShowsViewModel: ShowsViewModelProtocol {

    private let findShows: FindShows
    private let fetchShowsByPage: FetchShowsByPage
    private let fetchShowById: FetchShowById
    private var cancellables = Set<AnyCancellable>()

    @Published public var state: ShowsState = .idle
    public var page: Int = 0

    public init(
        findShows: @escaping FindShows,
        fetchShowsByPage: @escaping FetchShowsByPage,
        fetchShowById: @escaping FetchShowById
    ) {
        self.findShows = findShows
        self.fetchShowsByPage = fetchShowsByPage
        self.fetchShowById = fetchShowById

    }

    public func onAppear() {
        fetchShows(page: page)
    }

    public func nextPage() {
        page += 1
        fetchShows(page: page)
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

    private func fetchShows(page: Int) {
        state = .loading
        fetchShowsByPage(page).sink { [weak self] result in
            switch result {
                case .failure(let error):
                    self?.state = .error(message: error.localizedDescription)
                case .finished:
                    break
            }
        } receiveValue: { [weak self] shows in
            self?.state = .loaded(shows: shows)
        }.store(in: &cancellables)
    }
}
