//
//  Show.swift
//  TVMazeApp
//
//  Created by marcos.brito on 02/09/21.
//

import Foundation

public struct Show: Model {
    public let id: Int
    public let url: String
    public let name: String
    public let type: String
    public let language: String
    public let genres: [String]
    public let status: String
    public let runtime: Int
    public let averageRuntime: Int
    public let premiered: String
    public let officialSite: String
    public let schedule: Schedule
    public let rating: Rating
    public let weight: Int
    public let network: TVNetwork
    public let webChannel: WebChannel?
    public let dvdCountry: String?
    public let externals: Externals
    public let image: ShowImage
    public let summary: String
    public let updated: Int
    public let links: ShowLink
}
