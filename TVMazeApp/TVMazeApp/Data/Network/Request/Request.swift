//
//  Request.swift
//  TVMazeApp
//
//  Created by marcos.brito on 03/09/21.
//

import Foundation

public protocol Request {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var contentType: String { get }
    var body: [String: Any]? { get }
    var headers: [String: String]? { get }
    associatedtype ReturnType: Codable
}

extension Request {
    private func requestBodyFrom(params: [String: Any]?) -> Data? {
        guard let params = params else { return nil }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return nil
        }
        return httpBody
    }

    func asURLRequest() -> URLRequest? {
        guard let urlComponents = URLComponents(string: baseURL),
              let finalURL = urlComponents.url else { return nil }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.httpBody = requestBodyFrom(params: body)
        let defaultHeaders: [String: String] = [
            "Content-Type": contentType,
            "Accept": contentType
        ]
        request.allHTTPHeaderFields = defaultHeaders.merging(headers ?? [:], uniquingKeysWith: { (first, _) in first })
        return request
    }
}
