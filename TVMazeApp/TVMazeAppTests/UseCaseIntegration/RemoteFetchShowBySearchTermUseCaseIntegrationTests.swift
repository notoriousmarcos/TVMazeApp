//
//  RemoteFetchShowBySearchTermUseCaseIntegrationTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 04/09/21.
//

import XCTest
import CoreData
@testable import TVMazeApp

class RemoteFetchShowBySearchTermUseCaseIntegrationTests: XCTestCase {

    func testRemoteFetchShowBySearchTermUseCase_fetch_ShouldReceiveShows() {
        // Arrange
        let httpClient = NativeHTTPClient()
        let sut = RemoteFetchShowBySearchTermUseCase(httpClient: httpClient)

        let exp = expectation(description: "Waiting request")
        // Act
        let cancellable = sut.execute(searchTerm: "Dexter").sink { _ in
            exp.fulfill()
        } receiveValue: { shows in
            XCTAssertFalse(shows.isEmpty)
        }

        wait(for: [exp], timeout: 5)
        cancellable.cancel()
    }
}
