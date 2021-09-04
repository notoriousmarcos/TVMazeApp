//
//  ShowBySearchRequest.swift
//  TVMazeApp
//
//  Created by marcos.brito on 04/09/21.
//

import Foundation

public class ShowBySearchRequest: Request {
    public typealias ReturnType = [Show]

    public let baseURL: String = "https://api.tvmaze.com/shows"
    public let method: HTTPMethod = .get
    public let contentType: String = "application/json"
    public let params: [String: Any]?
    public let body: [String: Any]? = nil
    public let headers: [String: String]? = nil

    init(search: String) {
        params = ["q": search]
    }
}
