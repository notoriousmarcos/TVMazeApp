//
//  ShowViewModel.swift
//  TVMazeApp
//
//  Created by marcos.brito on 05/09/21.
//

import Combine

public protocol ShowDetailViewModelProtocol: ObservableObject {
    typealias FetchEpisodesByShow = (Show) -> AnyPublisher<[Episode], DomainError>

    var state: ShowDetailState { get }
    var episodes: [Episode] { get }
    var show: Show { get }

    func onAppear()
}

public final class ShowDetailViewModel: ShowDetailViewModelProtocol {

    private let fetchEpisodesByShow: FetchEpisodesByShow
    private var cancellables = Set<AnyCancellable>()

    @Published public var state: ShowDetailState = .idle
    @Published public var episodes: [Episode] = []
    public let show: Show

    public init(
        show: Show,
        fetchEpisodesByShow: @escaping FetchEpisodesByShow
    ) {
        self.show = show
        self.fetchEpisodesByShow = fetchEpisodesByShow
    }

    public func onAppear() {
        state = .loading
        fetchEpisodesByShow(show).sink { [weak self] result in
            switch result {
                case .failure(let error):
                    self?.state = .error(message: error.localizedDescription)
                case .finished:
                    break
            }
        } receiveValue: { [weak self] episodes in
            self?.episodes += episodes
            self?.state = .loaded(episodes: episodes)
        }.store(in: &cancellables)
    }
}
