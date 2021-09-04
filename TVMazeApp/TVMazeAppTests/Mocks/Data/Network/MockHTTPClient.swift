//
//  MockHTTPGetClient.swift
//  ShortlyTests
//
//  Created by marcos.brito on 28/08/21.
//

import Foundation
import Combine
import XCTest
@testable import TVMazeApp

class MockHTTPClient: HTTPClient {
    var result: Codable?
    var error: HTTPError?

    func dispatch<ReturnType: Codable>(request: URLRequest) -> AnyPublisher<ReturnType, HTTPError> {
        if let result = result as? ReturnType {
            return Just(result)
                .setFailureType(to: HTTPError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: error ?? .unknown)
            .eraseToAnyPublisher()
    }
}
