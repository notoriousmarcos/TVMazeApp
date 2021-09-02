//
//  HTTPGetClient.swift
//  Shortly
//
//  Created by marcos.brito on 28/08/21.
//

import Foundation
import Combine

public protocol HTTPGetClient {
    typealias Result = Swift.Result<Codable?, HTTPError>
    func get<ReturnType: Codable>(request: URLRequest) -> AnyPublisher<ReturnType, HTTPError>
}
