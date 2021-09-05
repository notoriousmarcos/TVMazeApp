//
//  SearchShowsViewModelTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 04/09/21.
//

import Combine
import XCTest
@testable import TVMazeApp

class SearchShowsViewModelTests: XCTestCase {

    func testSearchShowsViewModel_searchTerm_ShouldCallfetchShows() {
        // Arrange
        let expectedStatesBehaviour: [ShowsState] = [
            .idle,
            .loading,
            .loaded(shows: [MockEntities.show])
        ]
        var findBehaviour: [String] = []
        var statesBehaviour: [ShowsState] = []
        let sut = SearchShowsViewModel(findShows: { searchTerm in
            findBehaviour.append(searchTerm)
            return self.makeSuccessPublisher(forValue: [MockEntities.show])
        }, fetchShowById: { _ in
            self.makeSuccessPublisher(forValue: MockEntities.show)
        })

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.search("search")

        // Assert
        XCTAssertEqual(findBehaviour, ["search"])
        XCTAssertEqual(statesBehaviour, expectedStatesBehaviour)
        cancellable.cancel()
    }

    func testSearchShowsViewModel_searchTermWithError_ShouldCallfetchShowError() {
        // Arrange
        let expectedStatesBehaviour: [ShowsState] = [
            .idle,
            .loading,
            .error(message: "The operation couldn’t be completed. (TVMazeApp.DomainError error 1.)")
        ]
        var findBehaviour: [String] = []
        var statesBehaviour: [ShowsState] = []
        let sut = SearchShowsViewModel(findShows: { searchTerm in
            findBehaviour.append(searchTerm)
            return self.makeFailPublisher(forError: .fetchError)
        }, fetchShowById: { _ in
            self.makeSuccessPublisher(forValue: MockEntities.show)
        })

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.search("search")

        // Assert
        XCTAssertEqual(findBehaviour, ["search"])
        XCTAssertEqual(statesBehaviour, expectedStatesBehaviour)
        cancellable.cancel()
    }

    func testShowsViewModel_open_ShouldCallfetchShow() {
        // Arrange
        let expectedStatesBehaviour: [ShowsState] = [
            .idle,
            .loading,
            .open(show: MockEntities.show)
        ]
        var openBehaviour: [Int] = []
        var statesBehaviour: [ShowsState] = []
        let sut = SearchShowsViewModel(findShows: { _ in
            return self.makeSuccessPublisher(forValue: [MockEntities.show])
        }, fetchShowById: { showId in
            openBehaviour.append(showId)
            return self.makeSuccessPublisher(forValue: MockEntities.show)
        })

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.open(show: MockEntities.show)

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
        let sut = SearchShowsViewModel(findShows: { _ in
            return self.makeSuccessPublisher(forValue: [MockEntities.show])
        }, fetchShowById: { showId in
            openBehaviour.append(showId)
            return self.makeFailPublisher(forError: .fetchError)
        })

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.open(show: MockEntities.show)

        // Assert
        XCTAssertEqual(openBehaviour, [1])
        XCTAssertEqual(statesBehaviour, expectedStatesBehaviour)
        cancellable.cancel()
    }

    private func makeSuccessPublisher<T>(forValue value: T) -> AnyPublisher<T, DomainError> {
        return Just(value)
            .setFailureType(to: DomainError.self)
            .eraseToAnyPublisher()
    }

    private func makeFailPublisher<T>(forError error: DomainError) -> AnyPublisher<T, DomainError> {
        return Fail(error: error)
            .eraseToAnyPublisher()
    }
}
