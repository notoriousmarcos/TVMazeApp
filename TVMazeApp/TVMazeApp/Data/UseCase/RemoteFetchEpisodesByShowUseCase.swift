//
//  RemoteFetchEpisodesByShowUseCase.swift
//  TVMazeApp
//
//  Created by marcos.brito on 03/09/21.
//

import Foundation
import Combine

public class RemoteFetchEpisodesByShowUseCase: FetchEpisodesByShowUseCase {

    private let httpClient: HTTPClient

    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    public func execute(show: Show) -> AnyPublisher<[Episode], DomainError> {
        guard let urlRequest = EpisodesByShowRequest(showId: show.id).asURLRequest() else {
            return Fail(outputType: [Episode].self, failure: DomainError.unknown).eraseToAnyPublisher()
        }
        return httpClient.dispatch(request: urlRequest).mapError { _ -> DomainError in
            return .fetchError
        }.eraseToAnyPublisher()
    }
}
