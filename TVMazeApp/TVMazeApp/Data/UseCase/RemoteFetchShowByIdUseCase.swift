//
//  RemoteFetchShowByIdUseCase.swift
//  TVMazeApp
//
//  Created by marcos.brito on 03/09/21.
//

import Foundation
import Combine

public class RemoteFetchShowByIdUseCase: FetchShowByIdUseCase {

    private let httpClient: HTTPClient

    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    public func execute(id: Int) -> AnyPublisher<Show, DomainError> {
        guard let urlRequest = ShowByIdRequest(id: id).asURLRequest() else {
            return Fail(outputType: Show.self, failure: DomainError.unknown).eraseToAnyPublisher()
        }
        return httpClient.dispatch(request: urlRequest).mapError { _ -> DomainError in
            return .fetchError
        }.eraseToAnyPublisher()
    }
}
