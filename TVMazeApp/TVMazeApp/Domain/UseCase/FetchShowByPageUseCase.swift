//
//  FetchShowUseCase.swift
//  TVMazeApp
//
//  Created by marcos.brito on 02/09/21.
//

import Combine

public protocol FetchShowByPageUseCase {
    func execute(page: Int) -> AnyPublisher<[Show], Error>
}
