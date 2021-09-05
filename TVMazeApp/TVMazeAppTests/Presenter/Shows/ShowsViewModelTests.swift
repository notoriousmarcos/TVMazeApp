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
        let expectedStatesBehaviour: [ShowsState] = [.idle, .loading, .loaded(shows: [Mocks.show])]
        var fetchByPageCount = 0
        var statesBehaviour: [ShowsState] = []
        let sut = ShowsViewModel(fetchShowsByPage: { page in
            fetchByPageCount += 1
            XCTAssertEqual(page, 0)
            return Mocks.makeSuccessPublisher(forValue: [Mocks.show])
        }, fetchShowById: { _ in
            Mocks.makeSuccessPublisher(forValue: Mocks.show)
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
        }, fetchShowById: { _ in
            Mocks.makeSuccessPublisher(forValue: Mocks.show)
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
        let expectedStatesBehaviour: [ShowsState] = [
            .idle,
            .loading,
            .loaded(shows: [Mocks.show]),
            .loading,
            .loaded(shows: [Mocks.show])
        ]
        var fetchByPageBehaviour: [Int] = []
        var statesBehaviour: [ShowsState] = []
        let sut = ShowsViewModel(fetchShowsByPage: { page in
            fetchByPageBehaviour.append(page)
            return Mocks.makeSuccessPublisher(forValue: [Mocks.show])
        }, fetchShowById: { _ in
            Mocks.makeSuccessPublisher(forValue: Mocks.show)
        })

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.onAppear()
        sut.nextPage()

        // Assert
        XCTAssertEqual(fetchByPageBehaviour, [0, 1])
        XCTAssertEqual(statesBehaviour, expectedStatesBehaviour)
        cancellable.cancel()
    }

    func testShowsViewModel_open_ShouldCallfetchShow() {
        // Arrange
        let expectedStatesBehaviour: [ShowsState] = [
            .idle,
            .loading,
            .open(show: Mocks.show)
        ]
        var openBehaviour: [Int] = []
        var statesBehaviour: [ShowsState] = []
        let sut = ShowsViewModel(fetchShowsByPage: { _ in
            return Mocks.makeSuccessPublisher(forValue: [])
        }, fetchShowById: { showId in
            openBehaviour.append(showId)
            return Mocks.makeSuccessPublisher(forValue: Mocks.show)
        })

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.open(show: Mocks.show)

        // Assert
        XCTAssertEqual(openBehaviour, [1])
        XCTAssertEqual(statesBehaviour, expectedStatesBehaviour)
        cancellable.cancel()
    }

    func testShowsViewModel_openWithError_ShouldCallfetchShowWithError() {
        // Arrange
        let expectedStatesBehaviour: [ShowsState] = [
            .idle,
            .loading,
            .error(message: "The operation couldn’t be completed. (TVMazeApp.DomainError error 1.)")
        ]
        var openBehaviour: [Int] = []
        var statesBehaviour: [ShowsState] = []
        let sut = ShowsViewModel(fetchShowsByPage: { _ in
            return Mocks.makeSuccessPublisher(forValue: [])
        }, fetchShowById: { showId in
            openBehaviour.append(showId)
            return Mocks.makeFailPublisher(forError: .fetchError)
        })

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.open(show: Mocks.show)

        // Assert
        XCTAssertEqual(openBehaviour, [1])
        XCTAssertEqual(statesBehaviour, expectedStatesBehaviour)
        cancellable.cancel()
    }
}