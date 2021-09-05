//
//  ShowViewModelTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 04/09/21.
//

import Combine
import XCTest
@testable import TVMazeApp

class ShowDetailViewModelTests: XCTestCase {

    func testShowViewModel_onAppear_ShouldCallfetchEpisodes() {
        // Arrange
        let expectedStatesBehaviour: [ShowDetailState] = [.idle, .loading, .loaded(episodes: [Mocks.episode])]
        var fetchEpisodesCount = 0
        var statesBehaviour: [ShowDetailState] = []
        let sut = ShowDetailViewModel(
            show: Mocks.show) { show in
            fetchEpisodesCount += 1
            XCTAssertEqual(show, Mocks.show)
            return Mocks.makeSuccessPublisher(forValue: [Mocks.episode])
        }

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.onAppear()

        // Assert
        XCTAssertEqual(fetchEpisodesCount, 1)
        XCTAssertEqual(statesBehaviour, expectedStatesBehaviour)
        cancellable.cancel()
    }

    func testShowViewModel_onAppearWithError_ShouldCallfetchShowError() {
        // Arrange
        let expectedStatesBehaviour: [ShowDetailState] = [
            .idle,
            .loading,
            .error(message: "The operation couldn’t be completed. (TVMazeApp.DomainError error 1.)")
        ]
        var fetchEpisodesCount = 0
        var statesBehaviour: [ShowDetailState] = []
        let sut = ShowDetailViewModel(
            show: Mocks.show) { show in
            fetchEpisodesCount += 1
            XCTAssertEqual(show, Mocks.show)
            return Mocks.makeFailPublisher(forError: .fetchError)
        }

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.onAppear()

        // Assert
        XCTAssertEqual(fetchEpisodesCount, 1)
        XCTAssertEqual(statesBehaviour, expectedStatesBehaviour)
        cancellable.cancel()
    }
}