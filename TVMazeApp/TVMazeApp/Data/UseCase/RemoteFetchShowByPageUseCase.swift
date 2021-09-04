//
//  RemoteFetchShowByPageUseCase.swift
//  TVMazeApp
//
//  Created by marcos.brito on 03/09/21.
//

import Foundation
import Combine

public class RemoteFetchShowByPageUseCase: FetchShowByPageUseCase {

    private let request: URLRequest
    private let httpClient: HTTPClient

    public init(request: URLRequest, httpClient: HTTPClient) {
        self.request = request
        self.httpClient = httpClient
    }

    public func execute(page: Int) -> AnyPublisher<[Show], DomainError> {
        httpClient.dispatch(request: request).mapError { error -> DomainError in
            return .dataNotFound
        }.eraseToAnyPublisher()
    }
}
