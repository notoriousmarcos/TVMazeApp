//
//  Episode.swift
//  TVMazeApp
//
//  Created by marcos.brito on 01/09/21.
//

import Foundation

public struct Episode: Model {
    private enum CodingKeys: String, CodingKey {
        case id
        case url
        case name
        case number
        case season
        case type
        case airdate
        case airtime
        case airstamp
        case runtime
        case summary
        case image
        case links = "_links"
    }

    public let id: Int
    public let url: String
    public let name: String
    public let number: Int
    public let season: Int
    public let type: String
    public let airdate: String?
    public let airtime: String?
    public let airstamp: String?
    public let runtime: Int?
    public let summary: String?
    public let image: ShowImage?
    public let links: ShowLink?
}
