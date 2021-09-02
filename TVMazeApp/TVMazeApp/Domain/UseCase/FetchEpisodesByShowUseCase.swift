//
//  FetchEpisodesByShowUseCase.swift
//  TVMazeApp
//
//  Created by marcos.brito on 02/09/21.
//

import Combine

public protocol FetchEpisodesByShowUseCase {
    func execute(show: Show) -> AnyPublisher<[Episode], DomainError>
}
