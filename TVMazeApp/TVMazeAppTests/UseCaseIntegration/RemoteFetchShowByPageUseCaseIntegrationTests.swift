//
//  RemoteFetchShowByPageUseCaseIntegrationTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 04/09/21.
//

import XCTest
import CoreData
@testable import TVMazeApp

class RemoteFetchShowByPageUseCaseIntegrationTests: XCTestCase {

    func testRemoteFetchShowByPageUseCase_fetch_ShouldReceiveShows() {
        // Arrange
        let httpClient = NativeHTTPClient()
        let sut = RemoteFetchShowByPageUseCase(httpClient: httpClient)

        let exp = expectation(description: "Waiting request")
        // Act
        let cancellable = sut.execute(page: 0).sink { _ in
            exp.fulfill()
        } receiveValue: { shows in
            print(shows)
            XCTAssertFalse(shows.isEmpty)
        }

        wait(for: [exp], timeout: 5)
        cancellable.cancel()
    }
}
