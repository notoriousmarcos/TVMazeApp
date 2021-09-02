//
//  FetchShowBySearchtermUseCase.swift
//  TVMazeApp
//
//  Created by marcos.brito on 02/09/21.
//

import Combine

public protocol FetchShowBySearchTermUseCase {
    func execute(searchTerm: String) -> AnyPublisher<[Show], DomainError>
}
