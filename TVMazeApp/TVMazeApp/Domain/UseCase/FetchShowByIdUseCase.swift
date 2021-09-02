//
//  FetchShowByIdUseCase.swift
//  TVMazeApp
//
//  Created by marcos.brito on 02/09/21.
//

import Combine

public protocol FetchShowByIdUseCase {
    func execute(id: Int) -> AnyPublisher<[Show], DomainError>
}
