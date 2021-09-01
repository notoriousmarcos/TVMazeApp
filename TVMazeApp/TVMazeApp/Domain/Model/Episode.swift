//
//  Episode.swift
//  TVMazeApp
//
//  Created by marcos.brito on 01/09/21.
//

import Foundation

public struct Episode: Model {
    public var id: Int
    public var name: String
    public var number: Int
    public var season: Int
    public var summary: String?
    public var image: String?
}
