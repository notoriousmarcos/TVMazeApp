//
//  ShowViewModel.swift
//  TVMazeApp
//
//  Created by marcos.brito on 05/09/21.
//

import Combine

public protocol ShowDetailViewModelProtocol: ObservableObject {
    typealias FetchShowById = (Int) -> AnyPublisher<Show, DomainError>
    typealias FetchEpisodesByShow = (Show) -> AnyPublisher<[Episode], DomainError>

    var state: ShowDetailState { get }
    var episodes: [Episode] { get }
    var show: Show { get }

    func onAppear()
}

public final class ShowDetailViewModel: ShowDetailViewModelProtocol {

    private let fetchShowById: FetchShowById
    private let fetchEpisodesByShow: FetchEpisodesByShow
    private var cancellables = Set<AnyCancellable>()

    @Published public var state: ShowDetailState = .idle
    @Published public var episodes: [Episode] = []
    public var show: Show

    public init(
        show: Show,
        fetchShowById: @escaping FetchShowById,
        fetchEpisodesByShow: @escaping FetchEpisodesByShow
    ) {
        self.show = show
        self.fetchShowById = fetchShowById
        self.fetchEpisodesByShow = fetchEpisodesByShow
    }

    public func onAppear() {
        state = .loading

        fetchShowById(show.id)
            .zip(fetchEpisodesByShow(show))
            .sink { [weak self] result in
            switch result {
                case .failure(let error):
                    self?.state = .error(message: error.localizedDescription)
                case .finished:
                    break
            }
        } receiveValue: { [weak self] show, episodes in
            self?.show = show
            self?.episodes += episodes
            self?.state = .loaded(episodes: episodes)
        }.store(in: &cancellables)
    }
}
