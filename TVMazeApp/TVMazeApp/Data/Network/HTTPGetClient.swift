//
//  HTTPGetClient.swift
//  Shortly
//
//  Created by marcos.brito on 28/08/21.
//

import Foundation
import Combine

public protocol HTTPGetClient {
    func get<ReturnType: Codable>(request: URLRequest) -> AnyPublisher<ReturnType, HTTPError>
}
