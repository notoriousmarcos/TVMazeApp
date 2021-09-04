//
//  EpisodesByShowRequest.swift
//  TVMazeApp
//
//  Created by marcos.brito on 02/09/21.
//

import Combine

public struct EpisodesByShowRequest: Request {
    public typealias ReturnType = [Episode]

    public let baseURL: String
    public let method: HTTPMethod = .get
    public let contentType: String = "application/json"
    public let params: [String: Any]? = nil
    public let body: [String: Any]? = nil
    public let headers: [String: String]? = nil

    public init(showId: Int) {
        baseURL = "https://api.tvmaze.com/shows/\(showId)/episodes"
    }
}
