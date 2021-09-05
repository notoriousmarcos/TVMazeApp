//
//  ShowLink.swift
//  TVMazeApp
//
//  Created by marcos.brito on 02/09/21.
//

import Foundation

public struct ShowLink: Model {
    private enum CodingKeys: String, CodingKey {
        case current = "self"
        case previousepisode
    }

    public let current: Link
    public let previousepisode: Link?
}
