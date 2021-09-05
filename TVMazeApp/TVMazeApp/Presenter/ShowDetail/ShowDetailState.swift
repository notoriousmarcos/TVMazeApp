//
//  ShowState.swift
//  TVMazeApp
//
//  Created by marcos.brito on 05/09/21.
//

import Foundation

public enum ShowDetailState: Equatable {
    case idle
    case loaded(episodes: [Episode])
    case loading
    case error(message: String)
}
