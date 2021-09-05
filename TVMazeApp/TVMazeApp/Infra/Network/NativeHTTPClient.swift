//
//  NativeHTTPClient.swift
//  TVMazeApp
//
//  Created by marcos.brito on 03/09/21.
//

import Foundation
import Combine

public class NativeHTTPClient: HTTPClient {
    public let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func dispatch<ReturnType: Codable>(request: URLRequest) -> AnyPublisher<ReturnType, HTTPError> {
        return session
            .dataTaskPublisher(for: request)
            .tryMap({ [weak self] data, response in
                if let response = response as? HTTPURLResponse,
                   !(200...299).contains(response.statusCode) {
                    throw self?.handleError(response.statusCode) ?? .unknown
                }
                return data
            })
            .decode(type: ReturnType.self, decoder: JSONDecoder())
            .mapError { [weak self] error in
                guard let error = error as? HTTPError else {
                    return self?.handleError(error) ?? .unknown
                }
                return error
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func handleError(_ statusCode: Int) -> HTTPError {
        switch statusCode {
            case 400: return .badRequest
            case 401: return .unauthorized
            case 403: return .forbidden
            case 404: return .notFound
            case 500: return .serverError
            default: return .unknown
        }
    }

    private func handleError(_ error: Error) -> HTTPError {
        return .unknown
    }
}
