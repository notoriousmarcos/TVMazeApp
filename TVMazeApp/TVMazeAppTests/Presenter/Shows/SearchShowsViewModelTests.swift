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
        let expectedShows: [Show] = [Mocks.show]
        let expectedStatesBehaviour: [ShowsState] = [
            .idle,
            .loading,
            .loaded(shows: [Mocks.show])
        ]
        var findBehaviour: [String] = []
        var statesBehaviour: [ShowsState] = []
        let sut = SearchShowsViewModel(findShows: { searchTerm in
            findBehaviour.append(searchTerm)
            return Mocks.makeSuccessPublisher(forValue: [Mocks.show])
        }, fetchShowById: { _ in
            Mocks.makeSuccessPublisher(forValue: Mocks.show)
        })

        let cancellable = sut.$state.sink { state in
            statesBehaviour.append(state)
        }

        // Act
        sut.search("search")

        // Assert
        XCTAssertEqual(findBehaviour, ["search"])
        XCTAssertEqual(statesBehaviour, expectedStatesBehaviour)
        XCTAssertEqual(sut.shows, expectedShows)
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
            return Mocks.makeFailPublisher(forError: .fetchError)
        }, fetchShowById: { _ in
            Mocks.makeSuccessPublisher(forValue: Mocks.show)
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
}
