//
//  ShowsViewModelTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 04/09/21.
//

import Combine
import XCTest
@testable import TVMazeApp

class ShowsViewModelTests: XCTestCase {

    func testShowsViewModel_onAppear_ShouldCallfetchShowsByPageZero() {
        // Arrange
        let expectedShows: [Show] = [Mocks.show]
        let expectedStatesBehaviour: [ShowsState] = [.idle, .loading, .loaded(shows: [Mocks.show])]
        var fetchByPageCount = 0
        var statesBehaviour: [ShowsState] = []
        let sut = ShowsViewModel(fetchShowsByPage: { page in
            fetchByPageCount += 1
            XCTAssertEqual(page, 0)
            return Mocks.makeSuccessPublisher(forValue: [Mocks.show])
        })

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.onAppear()

        // Assert
        XCTAssertEqual(fetchByPageCount, 1)
        XCTAssertEqual(statesBehaviour, expectedStatesBehaviour)
        XCTAssertEqual(sut.shows, expectedShows)
        cancellable.cancel()
    }

    func testShowsViewModel_onAppearWithError_ShouldCallfetchShowError() {
        // Arrange
        let expectedStatesBehaviour: [ShowsState] = [
            .idle,
            .loading,
            .error(message: "The operation couldn’t be completed. (TVMazeApp.DomainError error 1.)")
        ]
        var fetchByPageCount = 0
        var statesBehaviour: [ShowsState] = []
        let sut = ShowsViewModel(fetchShowsByPage: { page in
            fetchByPageCount += 1
            XCTAssertEqual(page, 0)
            return Mocks.makeFailPublisher(forError: .fetchError)
        })

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.onAppear()

        // Assert
        XCTAssertEqual(fetchByPageCount, 1)
        XCTAssertEqual(statesBehaviour, expectedStatesBehaviour)
        cancellable.cancel()
    }

    func testShowsViewModel_nextPage_ShouldCallfetchShows() {
        // Arrange
        let expectedShows: [Show] = [Show](repeating: Mocks.show, count: 32)
        let expectedStatesBehaviour: [ShowsState] = [
            .idle,
            .loading,
            .loaded(shows: [Show](repeating: Mocks.show, count: 16)),
            .loaded(shows: [Show](repeating: Mocks.show, count: 16))
        ]
        var fetchByPageBehaviour: [Int] = []
        var statesBehaviour: [ShowsState] = []
        let sut = ShowsViewModel(fetchShowsByPage: { page in
            fetchByPageBehaviour.append(page)
            let shows = [Show](repeating: Mocks.show, count: 16)
            return Mocks.makeSuccessPublisher(forValue: shows)
        })

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.onAppear()
        sut.nextPageIdNeeded(1)
        sut.nextPageIdNeeded(9)

        // Assert
        XCTAssertEqual(fetchByPageBehaviour, [0, 1])
        XCTAssertEqual(statesBehaviour, expectedStatesBehaviour)
        XCTAssertEqual(sut.shows, expectedShows)
        cancellable.cancel()
    }
}
