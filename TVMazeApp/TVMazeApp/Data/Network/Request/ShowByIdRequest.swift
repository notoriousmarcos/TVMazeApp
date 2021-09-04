//
//  ShowByIdRequest.swift
//  TVMazeApp
//
//  Created by marcos.brito on 04/09/21.
//

import Foundation

public struct ShowByIdRequest: Request {
    public typealias ReturnType = Show

    public let baseURL: String
    public let method: HTTPMethod = .get
    public let contentType: String = "application/json"
    public let params: [String: Any]? = nil
    public let body: [String: Any]? = nil
    public let headers: [String: String]? = nil

    public init(id: Int) {
        baseURL = "https://api.tvmaze.com/shows/\(id)"
    }
}
