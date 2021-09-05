//
//  ShowsState.swift
//  TVMazeApp
//
//  Created by marcos.brito on 05/09/21.
//

import Foundation

public enum ShowsState: Equatable {
    case idle
    case loaded(shows: [Show])
    case loading
    case error(message: String)
    case open(show: Show)
}
