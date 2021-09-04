//
//  DomainError.swift
//  TVMazeApp
//
//  Created by marcos.brito on 02/09/21.
//

import Foundation

public enum DomainError: Int, Error {
    case fetchError = 1
    case dataNotFound = 2
    case lastPageAchieved = 3
    case parseFailed = 4
    case rateLimitAchieved = 5
    case unknown = -1
}
