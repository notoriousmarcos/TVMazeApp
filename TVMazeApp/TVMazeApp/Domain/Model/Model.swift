//
//  ModelTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 01/09/21.
//

import Foundation

public protocol Model: Codable, Equatable {}

public extension Model {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
