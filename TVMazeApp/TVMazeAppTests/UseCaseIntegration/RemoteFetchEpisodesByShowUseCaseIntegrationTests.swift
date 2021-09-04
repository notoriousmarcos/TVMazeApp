//
//  RemoteFetchEpisodesByShowUseCaseIntegrationTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 04/09/21.
//

import XCTest
import CoreData
@testable import TVMazeApp

class RemoteFetchEpisodesByShowUseCaseIntegrationTests: XCTestCase {

    func testRemoteFetchEpisodesByShowUseCase_fetch_ShouldReceiveEpisodes() {
        // Arrange
        let httpClient = NativeHTTPClient()
        let sut = RemoteFetchEpisodesByShowUseCase(httpClient: httpClient)

        let exp = expectation(description: "Waiting request")
        // Act
        let cancellable = sut.execute(show: MockEntities.show).sink { _ in
            exp.fulfill()
        } receiveValue: { episodes in
            XCTAssertFalse(episodes.isEmpty)
        }

        wait(for: [exp], timeout: 5)
        cancellable.cancel()
    }
}
